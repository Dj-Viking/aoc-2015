#include <Windows.h>
#include <stdio.h>
#include "constants.h"
#include <vector>
#include <string>
#include <iostream>
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
#endif
    if (h == INVALID_HANDLE_VALUE)
    {
        OutputDebugStringA(GetLastErrorAsString());
        printf("ooops error when getting file handle %s", GetLastErrorAsString());
        return NULL;
    }
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
#endif
    if (result == 0)
    {
        const char *last_error = GetLastErrorAsString();
        OutputDebugStringA("[ERROR]:\n");
        OutputDebugStringA(last_error);
        OutputDebugStringA("\n");
        printf("oops couldn't open the file %s", last_error);
        return 1;
    }

    return result;
}

// split a string by a string separator
void split_and_alloc_string(std::vector<std::string> *lines, const std::string &str, const char *separator, bool only_for_lines)
{
    std::string::size_type pos = 0;
    std::string::size_type prev_pos = 0;

    while ((pos = str.find(separator, pos)) != std::string::npos)
    {
        std::string substr(str.substr(prev_pos, pos - prev_pos));

        lines->push_back(substr);

        prev_pos = ++pos;
    }

    // push last line
    lines->push_back(str.substr(prev_pos, pos - prev_pos));

    if (only_for_lines)
    {
        // remove extra \n at the beginning of each line
        for (std::vector<std::string>::iterator i = lines->begin();
             i < lines->end();
             i++)
        {
            i->assign(strtok((char *)i->c_str(), "\n"));

            std::cout << *i << std::endl;
        }
    }
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