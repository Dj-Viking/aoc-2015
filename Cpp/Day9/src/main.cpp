#include <stdio.h>
#include <Windows.h>
#include "utils.h"
#include "constants.h"
#include <string.h>
#include <string>
#include <iostream>
#include <vector>
#include <set>
#include <unordered_map>

#define PART_1 1
#define SAMPLE 1

typedef struct place
{
    std::string name;
    bool visited = false;
} Place;

typedef struct route
{
    Place start;
    Place connect; // start -> connect
    int distance;
} Route;

int main(void)
{
    void *h_file = 0;
    char file_buf[FILE_SIZE_LIMIT + 1] = {0};
    unsigned long lpNumberOfBytesRead = 0;
    int read_result = 0;
    std::vector<std::string> lines;
    std::vector<Route> allRoutes;

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

    // done with file at this point
    CloseHandle(h_file);

    std::string filestr = "";

    for (int i = 0; i < strlen(file_buf); i++)
    {
        // each character appended to string
        filestr += file_buf[i];
        // printf("%c", file_buf[i]);
    }

    // if i want all the lines the file needs to have \r\n at the end of it before null terminator
    split_and_alloc_string_lines(&lines, filestr);

    std::cout << filestr << std::endl;

    // std::cout << "vector items: ";

    std::vector<std::string> tokens;
    std::unordered_map<std::string, std::set<std::string>> routeMap;

    /// parsing lines into usable information
    for (std::vector<std::string>::iterator line = lines.begin();
         line < lines.end();
         line++)
    {
        std::vector<std::string> tokens;
        split_and_alloc_string_in_middle(&tokens, *line, " = "); // ["London to Belfast", "464"]
        Route route;

        std::vector<std::string> routeNames;
        split_and_alloc_string_in_middle(&routeNames, tokens.at(0), " to "); // ["London", "Belfast"]

        route.distance = std::stoi(tokens.at(1));
        route.start.name = routeNames.at(0);
        route.connect.name = routeNames.at(1);

        allRoutes.push_back(route);

        if (routeMap.find(routeNames.at(0)) != routeMap.end())
        {
            // found key
            routeMap[routeNames.at(0)].insert(routeNames.at(1));
        }
        else
        {
            // didn't find key
            // add the key and add in it's destination
            routeMap[routeNames.at(0)] = {};
            routeMap[routeNames.at(0)].insert(routeNames.at(1));
        }
    }

    std::cout << std::endl;

    OutputDebugStringA((LPCSTR)file_buf);
    return 0;
}