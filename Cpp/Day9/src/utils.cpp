#include <Windows.h>
#include <stdio.h>
#include "constants.h"
#include <iostream>
#include <vector>
#include <unordered_map>
#include <set>
#include <algorithm>

using RouteMap = std::unordered_map<std::string, std::set<std::string>>;
using RouteMap = std::unordered_map<std::string, std::set<std::string>>;
using TwoDimensionalStringArray = std::vector<std::vector<std::string>>;
using ConnectionDistanceMap = std::unordered_map<std::string, std::unordered_map<std::string, int>>;

// Returns the last Win32 error, in string format. Returns an empty string if there is no error.
[[nodiscard]] const char *GetLastErrorAsString(void) noexcept
{
    // Get the error message ID, if any.
    DWORD errorMessageID = ::GetLastError();
    if (errorMessageID == 0)
    {
        return ""; // No error message has been recorded
    }

    LPSTR messageBuffer = nullptr;

    // Ask Win32 to give us the string version of that message ID.
    // The parameters we pass in, tell Win32 to create the buffer that holds the message for us (because we don't yet know how long the message string will be).
    size_t size = FormatMessageA(FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
                                 NULL, errorMessageID, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPSTR)&messageBuffer, 0, NULL);

    const char *message(messageBuffer);

    // Free the Win32's string's buffer.
    LocalFree(messageBuffer);

    return message;
}

// the file has to be located relative to the executable file and not the source code file
[[nodiscard]] void *GetFileHandle(const char *relative_filepath) noexcept
{
    void *h = 0;
#if _WIN32
    h = CreateFileA(
        relative_filepath,
        GENERIC_READ,
        0,
        0,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        0);
    if (h == INVALID_HANDLE_VALUE)
    {
        OutputDebugStringA(GetLastErrorAsString());
        printf("ooops error when getting file handle %s", GetLastErrorAsString());
        return NULL;
    }
#endif
    return h;
}

int PlatformReadFile(void *file_handle, void *file_buf, unsigned long *lpNumberOfBytesRead)
{
    int result = 0;
#if _WIN32
    result = ReadFile(
        file_handle, file_buf,
        FILE_SIZE_LIMIT, lpNumberOfBytesRead,
        0);
    if (result == 0)
    {
        const char *last_error = GetLastErrorAsString();
        OutputDebugStringA("[ERROR]:\n");
        OutputDebugStringA(last_error);
        OutputDebugStringA("\n");
        printf("oops couldn't open the file %s", last_error);
        return 1;
    }
#endif

    return result;
}

// split a string with newlines into vector of strings that were separated by that newline
void split_and_alloc_string_lines(std::vector<std::string> *lines, std::string &str, const char *delimiter = "\r\n")
{
    int pos = 0;
    while (pos < str.size())
    {
        pos = str.find(delimiter);
        std::string subst = str.substr(0, pos);
        lines->push_back(str.substr(0, pos));
        str.erase(0, pos + strlen(delimiter));
    }
}
void split_and_alloc_string_in_middle(std::vector<std::string> *lines, std::string &str, const char *delimiter)
{
    int pos = 0;
    // get lhs of delim
    pos = str.find(delimiter);
    std::string lhs = str.substr(0, pos);
    lines->push_back(lhs);

    // get rhs of delim
    pos = pos + strlen(delimiter);
    std::string rhs = str.substr(pos, strlen(str.c_str()) - pos);
    lines->push_back(rhs);
}

void debug_route_map(RouteMap map)
{

    // Helper lambda function to print key-value pairs
    auto print_key_value = [](const std::string &key, const std::set<std::string> &value)
    {
        std::cout << "Key:[" << key << "] Value:[" << [](const std::set<std::string> val)
        {
            std::string output;
            for (std::set<std::string>::iterator item = val.begin();
                 item != val.end();
                 item++)
            {
                output += "\"";
                output += *item;
                if (item != val.end())
                {
                    output += "\",";
                }
            }

            return output;
        }(value) << "]\n";
    };

    for (const auto &[key, value] : map)
        print_key_value(key, value);
}

void str_trim_whitespace(std::string *str)
{
    str->erase(std::remove_if(str->begin(),
                              str->end(), ::isspace),
               str->end());
}

void str_trim_whitespace(std::vector<std::string>::iterator iter)
{
    iter->erase(std::remove_if(iter->begin(),
                               iter->end(), ::isspace),
                iter->end());
}

void getPermutations(std::vector<std::string> *places, TwoDimensionalStringArray *out)
{
    std::string place = "";
    std::vector<std::string> placeArr = {};
    for (auto iter = places->begin();
         iter < places->end();
         iter++)
    {
        // TODO: vector splice impl??
        // place = places->splice(i, 1)[0];
        placeArr.push_back(place);
        if (places->size() == 0)
        {
            // slice impl here
            // out->push_back(placeArr.slice())
        }
        getPermutations(places, out);
        // splice impl here
        // placeArr.pop() ?
    }
}

int calculateRouteDistance(std::vector<std::string> *route, ConnectionDistanceMap *connectionDistanceMap)
{
    int dist = 0;

    for (auto place = route->begin();
         place < route->end();
         place++)
    {
        if (place != route->begin())
        {
            auto previous = *(place -= 1);
            auto previousRecord = connectionDistanceMap->find(previous)->second;
            int d = previousRecord.find(*place)->second;
            dist += d;
        }
    }

    return dist;
}

void initializeConnectionDistances(
    std::vector<std::string> *places,
    ConnectionDistanceMap *connectionDistances,
    std::string place1,
    std::string place2,
    int placeDistance,
    bool last)
{
    // didn't find in vector
    if (!(std::find(
              places->begin(), places->end(), place1) < places->end()))
    {
        places->push_back(place1);
    }

    std::unordered_map<std::string, int> distMap = {};
    distMap.insert(std::pair<std::string, int>(place2, placeDistance));
    connectionDistances->insert(std::pair<std::string, std::unordered_map<std::string, int>>(place1, distMap));

    if (!last)
    {
        initializeConnectionDistances(places, connectionDistances, place2, place1, placeDistance, true);
    }
}