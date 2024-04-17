#include <stdio.h>
#include <Windows.h>
#include "utils.h"
#include "constants.h"
#include <string.h>
#include <string>
#include <iostream>
#include <vector>
#include <set>
#include <map>

#define SAMPLE 0
#define DEBUG 0

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

    std::map<
        std::string,
        std::map<std::string, int>>
        connectionDistances = {};

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

        if (!(connectionDistances.find(route.start.name) != connectionDistances.end()))
        {
            connectionDistances[route.start.name] = {};
        }
        connectionDistances[route.start.name][route.connect.name] = route.distance;

        if (!(connectionDistances.find(route.connect.name) != connectionDistances.end()))
        {
            connectionDistances[route.connect.name] = {};
        }
        connectionDistances[route.connect.name][route.start.name] = route.distance;

        // didn't find in vector
        if (!(std::find(
                  places.begin(), places.end(), route.start.name) < places.end()))
        {
            places.push_back(route.start.name);
        }

        if (!(std::find(
                  places.begin(), places.end(), route.connect.name) < places.end()))
        {
            places.push_back(route.connect.name);
        }

#if DEBUG
        debugConnectionDistances(&connectionDistances);
        std::cout << "\n -------------- \n"
                  << std::endl;
#endif
    }

#if DEBUG

    std::cout << "\n --------- debug connection map NOW ---------\n" << std::endl;
    debugConnectionDistances(&connectionDistances);
#endif
    // permutate
    getPermutations(places, placeArr, &routes);

#if DEBUG
    // debug routes
    for (auto route = routes.begin();
         route < routes.end();
         route++)
    {
        std::cout << "\n -------------- \n"
                  << std::endl;
        for (auto thing = route->begin();
             thing < route->end();
             thing++)
        {
            std::cout << "\n ---- \n"
                      << "routes created -> " << *thing << "\n"
                      << std::endl;
        }
    }
#endif

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