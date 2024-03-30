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

typedef struct place
{
    std::string name;
    bool visited = false;
} Place;

typedef struct route
{
    Place start;
    Place finish;
    int distance;
} Route;

int main(void)
{
    void *h_file = 0;
    char file_buf[FILE_SIZE_LIMIT + 1] = {0};
    unsigned long lpNumberOfBytesRead = 0;
    int read_result = 0;
    std::vector<std::string> lines;

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

    split_and_alloc_string(&lines, filestr, "\r\n", true);

    std::cout << filestr << std::endl;

    // std::cout << "vector items: ";

    std::vector<std::string> tokens;
    std::vector<Route> allRoutes;

    for (std::vector<std::string>::iterator i = lines.begin();
         i < lines.end();
         i++)
    {
        std::vector<std::string> tokens;
        split_and_alloc_string(&tokens, *i, "=", false);
        Route route;

        for (std::vector<std::string>::iterator j = tokens.begin();
             j < tokens.end();
             j++)
        {
            try
            {
                int converted = std::stoi(*j);
                if (converted != 0)
                {
                    route.distance = converted;
                }
            }
            catch (std::invalid_argument const &ex)
            {
                // the tokens separated from = here couldn't be converted to integer and are the destinations _ to _
                // parse destinations into the route struct
                std::vector<std::string> routeNames;
                split_and_alloc_string(&routeNames, *j, "t", false);
                for (std::vector<std::string>::iterator k = routeNames.begin();
                     k < routeNames.end();
                     k++)
                {
                    // for some reason if k is a " " just skip it
                    if (k->at(0) == ' ')
                    {
                        continue;
                    }
                    // remove extra o from the new split string... not sure how to split by a pattern yet
                    if (k != routeNames.begin() && k->at(0) == 'o')
                    {
                        k->assign(strtok((char *)k->c_str(), "o"));
                    }
                    if (k == routeNames.begin())
                    {
                        // Using the erase, remove_if, and ::isspace functions.
                        str_trim_whitespace(k);
                        route.start.name = *k;
                    }
                    else
                    {
                        str_trim_whitespace(k);
                        route.finish.name = *k;
                    }
                }
                continue;
            }
            allRoutes.push_back(route);
        }
    }
    std::cout << std::endl;

    // check list of structs

    for (std::vector<Route>::iterator s = allRoutes.begin();
         s < allRoutes.end();
         s++)
    {
        std::cout
            << "visited? " << (s->start.visited == 0 ? "false" : "true") << "\n"
            << s->start.name << "\n"
            << "->"
            << "\n"
            << "visited? " << (s->finish.visited == 0 ? "false" : "true") << "\n"
            << s->finish.name << "\n"
            << "distance: " << s->distance << "\n"
            << std::endl;
    }

    int possibleRoutes = 2 * allRoutes.size();

    // make hashmap of all 3 places and their connections??

    // this is BFS but completely forgot about how to do it

    OutputDebugStringA((LPCSTR)file_buf);
    return 0;
}