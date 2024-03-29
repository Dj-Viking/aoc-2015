#include <Windows.h>
#include <stdio.h>
#include "constants.h"
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