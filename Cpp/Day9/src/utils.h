
#ifndef UTILS_H
#define UTILS_H
#include <vector>
#include <string>
#include <unordered_map>
#include <set>

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

using RouteMap = std::unordered_map<std::string, std::set<std::string>>;
using TwoDimensionalStringArray = std::vector<std::vector<std::string>>;
using ConnectionDistanceMap = std::unordered_map<std::string, std::unordered_map<std::string, int>>;

void getPermutations(std::vector<std::string> &places, std::vector<std::string> &placeArr, TwoDimensionalStringArray *out);

void initializeConnectionDistances(std::vector<std::string> *places, ConnectionDistanceMap *connectionDistances, std::string place1, std::string place2, int placeDistance, bool last = false);

int calculateRouteDistance(TwoDimensionalStringArray::iterator route, ConnectionDistanceMap *connectionDistanceMap);

// update an array in place and return it's removed elements
std::vector<std::string> spliceStrArray(std::vector<std::string> &arrToSplice, int startIndex, int endIndex);

const char *GetLastErrorAsString(void);

void *GetFileHandle(const char *relative_filepath);

int PlatformReadFile(void *file_handle, void *file_buf, unsigned long *lpNumberOfBytesRead);

void split_and_alloc_string_lines(std::vector<std::string> *array, std::string &str, const char *delimiter = "\r\n");

void split_and_alloc_string_in_middle(std::vector<std::string> *array, std::string &str, const char *delimiter);

void str_trim_whitespace(std::string *str);

void str_trim_whitespace(std::vector<std::string>::iterator str);

void debug_route_map(RouteMap map);

#endif