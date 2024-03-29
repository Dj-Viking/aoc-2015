
#ifndef UTILS_H
#define UTILS
#include <vector>
#include <string>

const char *GetLastErrorAsString(void);

void *GetFileHandle(const char *relative_filepath);

int PlatformReadFile(void *file_handle, void *file_buf, unsigned long *lpNumberOfBytesRead);

void split_and_alloc_string(std::vector<std::string> *lines, const std::string &str, const char *separator);

#endif