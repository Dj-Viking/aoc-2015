#ifndef UTILS_H
#define UTILS

const char *GetLastErrorAsString(void);

void *GetFileHandle(const char *relative_filepath);

int PlatformReadFile(void *file_handle, void *file_buf, unsigned long *lpNumberOfBytesRead);

#endif