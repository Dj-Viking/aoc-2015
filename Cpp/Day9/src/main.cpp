#include <stdio.h>
#include <Windows.h>
#include "utils.h"
#include "constants.h"

#define PART_1 1
#define SAMPLE 1

int main(void)
{
    void *h_file = 0;
    const char *file_buf[FILE_SIZE_LIMIT + 1] = {0};
    unsigned long lpNumberOfBytesRead = 0;
    int read_result = 0;

    const char *last_error = 0;

#if SAMPLE
    h_file = GetFileHandle(sample_file_path);
#else
    h_file = GetFileHandle(input_file_path);
#endif

    if (h_file == NULL)
    {
        return 1;
    }

    read_result = PlatformReadFile(
        h_file,
        file_buf,
        &lpNumberOfBytesRead);

    if (read_result != 1)

    {
        return 1;
    }

    OutputDebugStringA((LPCSTR)file_buf);
    OutputDebugStringA("\n");
    return 0;
}