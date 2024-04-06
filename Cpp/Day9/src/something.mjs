import fs from "fs";
// @ts-check
var str = fs
    .readFileSync("C:/Users/ander/projects/aoc-2015/Cpp/Day9/src/input.txt", {
        encoding: "utf-8",
    })
    .trim();

// From http://stackoverflow.com/questions/9960908/permutations-in-javascript
var permArr = [],
    usedChars = [];

/**
 *
 * @param {string[]} input
 * @returns {string[][]}
 */
function permute(input) {
    let place = "";
    for (let i = 0; i < input.length; i++) {
        place = input.splice(i, 1)[0];
        usedChars.push(place);
        if (input.length == 0) {
            permArr.push(usedChars.slice());
        }
        permute(input);
        input.splice(i, 0, place);
        usedChars.pop();
    }
    return permArr;
}

// Now back to my code
var places = [];
var distance = {};

function addDistance(place1, place2, placeDistance, last) {
    if (places.indexOf(place1) === -1) places.push(place1);
    distance[place1] = distance[place1] || {};
    distance[place1][place2] = placeDistance;

    if (!last) addDistance(place2, place1, placeDistance, true);
}

function calculateRouteDistance(route) {
    var d = 0;
    route.forEach(function (place, i) {
        if (i > 0) {
            var lastPlace = route[i - 1];
            d += distance[lastPlace][place];
        }
    });
    return d;
}

str.split("\n").forEach(function (line) {
    var match = /^([a-z]+) to ([a-z]+) = ([0-9]+)/i.exec(line);
    var place1 = match[1];
    var place2 = match[2];
    var placeDistance = parseInt(match[3]);

    addDistance(place1, place2, placeDistance);
});

var routes = permute(places);
console.log("routes", routes);
var shortestDistance = calculateRouteDistance(routes[0]);
var longestDistance = shortestDistance;
routes.forEach(function (route) {
    var d = calculateRouteDistance(route);
    shortestDistance = Math.min(shortestDistance, d);
    longestDistance = Math.max(longestDistance, d);
});

console.log("Shortest: " + shortestDistance);
console.log("Longest: " + longestDistance);
