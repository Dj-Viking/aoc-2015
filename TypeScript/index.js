"use strict";
const { day3Input: fileText_ } = require("./lib");
let fileText = fileText_;
let example = "^>v<";
var Direction;
(function (Direction) {
    Direction["^"] = "north";
    Direction["v"] = "south";
    Direction["<"] = "east";
    Direction[">"] = "west";
})(Direction || (Direction = {}));
var DirectionName;
(function (DirectionName) {
    DirectionName["north"] = "^";
    DirectionName["south"] = "v";
    DirectionName["east"] = ">";
    DirectionName["west"] = "<";
})(DirectionName || (DirectionName = {}));
class Point {
    constructor(x, y) {
        this.x = 0;
        this.y = 0;
        this.visited = 1;
        this.x = x || 0;
        this.y = y || 0;
    }
    toString() {
        return `${this.x},${this.y}`;
    }
}
(function main() {
    const locationMap = new Map();
    const point = new Point(0, 0);
    locationMap.set(point.toString(), { visited: point.visited });
    let x = 0;
    let y = 0;
    for (const direction of fileText.split("")) {
        // for (const direction of example.split("") as DirectionVal[]) {
        if (direction === DirectionName.east) {
            x += 1;
            y += 0;
            const pt = new Point(x, y);
            if (!locationMap.has(pt.toString())) {
                locationMap.set(pt.toString(), { visited: pt.visited });
            }
            else {
                locationMap.get(pt.toString()).visited++;
            }
        }
        else if (direction === DirectionName.west) {
            x -= 1;
            y += 0;
            const pt = new Point(x, y);
            if (!locationMap.has(pt.toString())) {
                locationMap.set(pt.toString(), { visited: pt.visited });
            }
            else {
                locationMap.get(pt.toString()).visited++;
            }
        }
        else if (direction === DirectionName.north) {
            x -= 0;
            y += 1;
            const pt = new Point(x, y);
            if (!locationMap.has(pt.toString())) {
                locationMap.set(pt.toString(), { visited: pt.visited });
            }
            else {
                locationMap.get(pt.toString()).visited++;
            }
        }
        else if (direction === DirectionName.south) {
            x -= 0;
            y -= 1;
            const pt = new Point(x, y);
            if (!locationMap.has(pt.toString())) {
                locationMap.set(pt.toString(), { visited: pt.visited });
            }
            else {
                locationMap.get(pt.toString()).visited++;
            }
        }
    }
    const values = locationMap.values();
    let atleastOnce = 0;
    for (let i = 0; i < locationMap.size; i++) {
        const value = values.next().value;
        if (value.visited >= 1) {
            atleastOnce++;
        }
    }
    console.log("ANSWER PART 1", atleastOnce);
})();
