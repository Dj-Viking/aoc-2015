import fs from "fs";
// @ts-check
const str = fs
    .readFileSync("C:/Users/ander/projects/aoc-2015/Cpp/Day9/src/input.txt", {
        encoding: "utf-8",
    })
    .trim();

// From http://stackoverflow.com/questions/9960908/permutations-in-javascript

/**
 * @type {string[][]}
 */
const permArr = [];

/**
 * @type {string[]}
 */
const placeArr = [];

/**
 *
 * @param {string[]} input
 * @returns {string[][]}
 */
function permute(input) {
    let place = "";
    for (let i = 0; i < input.length; i++) {
        place = input.splice(i, 1)[0];
        placeArr.push(place);
        if (input.length == 0) {
            permArr.push(placeArr.slice());
        }
        permute(input);
        input.splice(i, 0, place);
        placeArr.pop();
    }
    return permArr;
}

/**
 * @type {string[]}
 */
const places = [];
/**
 * @type {Record<string, Record<string, number>>}
 */
const connectionDistances = {};

/**
 *
 * @param {string} place1
 * @param {string} place2
 * @param {number} placeDistance
 * @param {boolean | undefined} last
 */
function initializeConnectionDistances(place1, place2, placeDistance, last) {
    if (places.indexOf(place1) === -1) places.push(place1);
    connectionDistances[place1] = connectionDistances[place1] || {};
    connectionDistances[place1][place2] = placeDistance;

    if (!last) {
        initializeConnectionDistances(place2, place1, placeDistance, true);
    }
}

/**
 *
 * @param {string[]} route
 * @returns
 */
function calculateRouteDistance(route) {
    let d = 0;
    route.forEach(function (place, i) {
        if (i > 0) {
            const previous = route[i - 1];
            d += connectionDistances[previous][place];
        }
    });
    return d;
}

str.split("\n").forEach(function (line) {
    const match = /^([a-z]+) to ([a-z]+) = ([0-9]+)/i.exec(line);
    const place1 = match[1];
    const place2 = match[2];
    const placeDistance = parseInt(match[3]);

    initializeConnectionDistances(place1, place2, placeDistance);
});

console.log(connectionDistances);

const routes = permute(places);
// console.log("routes", routes);
let shortestDistance = calculateRouteDistance(routes[0]);
let longestDistance = shortestDistance;
routes.forEach(function (route) {
    const d = calculateRouteDistance(route);
    shortestDistance = Math.min(shortestDistance, d);
    longestDistance = Math.max(longestDistance, d);
});

console.log("Shortest: " + shortestDistance);
console.log("Longest: " + longestDistance);
