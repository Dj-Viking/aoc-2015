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

int main(void)
{
    void *h_file = 0;
    char file_buf[FILE_SIZE_LIMIT + 1] = {0};
    unsigned long lpNumberOfBytesRead = 0;
    int read_result = 0;
    std::vector<std::string> lines;
    TwoDimensionalStringArray routes = {};
    std::vector<std::string> permPlaceArr = {};
    std::vector<std::string> places = {};
    std::vector<std::string> placeArr = {};
    ConnectionDistanceMap connectionDistances = {};

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

    for (auto line = lines.begin();
         line < lines.end();
         line++)
    {
        std::vector<std::string> tokens = {};
        split_and_alloc_string_in_middle(&tokens, *line, " = ");
        Route route;

        std::vector<std::string> routeNames;
        split_and_alloc_string_in_middle(&routeNames, tokens.at(0), " to ");

        route.distance = std::stoi(tokens.at(1));
        route.start.name = routeNames.at(0);
        route.connect.name = routeNames.at(1);

        initializeConnectionDistances(
            places,
            &connectionDistances,
            route.start.name,
            route.connect.name,
            route.distance);
    }

    // TODO: debug connections...something isn't being added correctly there

    // permutate
    getPermutations(places, placeArr, &routes);

    // debug routes
    for (auto route = routes.begin();
        route < routes.end();
        route++)
    {
        std::cout << "\n -------------- \n" << std::endl;
        for (auto thing = route->begin();
            thing < route->end();
            thing++)
        {
            std::cout << "\n ---- \n" <<
                "routes created -> " << *thing << "\n" << std::endl;
        }

    }

    // get the shortest and longest distances
    int shortestDistance = calculateRouteDistance(routes.begin(), &connectionDistances);
    int longestDistance = shortestDistance;

    for (auto route = routes.begin();
         route < routes.end();
         route++)
    {
        int dist = calculateRouteDistance(route, &connectionDistances);
        shortestDistance = min(shortestDistance, dist);
        longestDistance = max(longestDistance, dist);
    }

    std::cout << shortestDistance << std::endl;
    std::cout << longestDistance << std::endl;
}