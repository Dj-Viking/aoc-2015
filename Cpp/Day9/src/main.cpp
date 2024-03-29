#include <stdio.h>
#include <Windows.h>
#include "utils.h"
#include "constants.h"
#include <string.h>
#include <string>
#include <iostream>
#include <vector>

#define PART_1 1
#define SAMPLE 1

int main(void)
{
    void *h_file = 0;
    char file_buf[FILE_SIZE_LIMIT + 1] = {0};
    unsigned long lpNumberOfBytesRead = 0;
    int read_result = 0;
    std::vector<std::string> lines;

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

    std::string filestr = "";

    for (int i = 0; i < strlen(file_buf); i++)
    {
        // each character appended to string
        filestr += file_buf[i];
        // printf("%c", file_buf[i]);
    }

    printf("\n\n");

    split_and_alloc_string(&lines, filestr, "\r\n");

    std::cout << filestr << std::endl;

    std::cout << "vector items: ";

    for (std::vector<std::string>::iterator i = lines.begin();
         i < lines.end();
         i++)
    {
        std::cout << "\n"
                  << *i
                  << "\n";
    }
    std::cout << std::endl;

    OutputDebugStringA((LPCSTR)file_buf);
    return 0;
}