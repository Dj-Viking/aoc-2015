#include <Windows.h>
#include <stdio.h>
#include "constants.h"
#include <iostream>
#include <vector>
#include <unordered_map>
#include <map>
#include <set>
#include <algorithm>
#include <iterator>

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

std::vector<std::string> spliceStrArray(
    std::vector<std::string> &arrToSplice,
    int startIndex,
    int endIndex)
{
    std::vector<std::string>::iterator start =
        (arrToSplice.begin() + startIndex);
    std::vector<std::string>::iterator end =
        arrToSplice.begin() + endIndex + 1;

    static std::vector<std::string> result(endIndex - startIndex + 1);

    if (start != end && *end != "")
    {
        result.at(0) = *start;
        result.at(1) = *end;
    }
    else
    {
        result.at(0) = *start;
    }

    auto debugresbegin = result.begin();
    auto debugresend = result.end() - 1;

    std::string eraseResult = *(arrToSplice.erase(std::remove(start, start, *start)));

    return result;
}

void getPermutations(std::vector<std::string> &places, std::vector<std::string> &placeArr, TwoDimensionalStringArray *out)
{
    std::string place = "";

    for (auto iter = places.begin();
         iter < places.end();
         iter++)
    {
        int index;
        if (iter != places.end())
        {
            index = iter - places.begin();
        }
        else
        {
            // should be unreachable i hope
            index = -1;
        }
        if (index > 1)
        {
            place = spliceStrArray(places, 1, 1).at(0);
        }
        else
        {

            place = spliceStrArray(places, index, 1).at(0);
        }
        placeArr.push_back(place);

        if (places.size() == 0)
        {
            // slice impl here
            // out->push_back([...placeArr])

            std::vector<std::string> copyArr = placeArr;

            out->push_back(copyArr);
        }
        getPermutations(places, placeArr, out);

        // input.splice(i, 0, place);
        places.insert(places.begin(), place);
        placeArr.pop_back();
    }
}

int calculateRouteDistance(TwoDimensionalStringArray::iterator route, std::map<std::string, std::map<std::string, int>> *connectionDistanceMap)
{
    int dist = 0;

    for (auto place = route->begin();
         place < route->end();
         place++)
    {
        if (place != route->begin())
        {
            auto previous = *(std::prev(place));
            auto previousRecord = connectionDistanceMap->find(previous)->second;
            int d = previousRecord.find(*place)->second;
            dist += d;
        }
    }

    return dist;
}

void debugConnectionDistances(std::map<std::string, std::map<std::string, int>> *connectionDistances)
{
    for (auto place = connectionDistances->begin();
         place != connectionDistances->end();
         place++)
    {
        std::cout << "* " << place->first << std::endl;
        for (auto placeMap = place->second.begin();
             placeMap != place->second.end();
             placeMap++)
        {
            std::cout << " connection -> " << placeMap->first << " | distance - " << placeMap->second << std::endl;
        }
    }
}