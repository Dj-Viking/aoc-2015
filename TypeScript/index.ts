const { day3Input: fileText_ } = require("./lib");

let fileText: string = fileText_;
let example: string = "^v";
enum Direction {
    "^" = "north",
    "v" = "south",
    "<" = "east",
    ">" = "west",
}

enum DirectionName {
    "north" = "^",
    "south" = "v",
    "east" = ">",
    "west" = "<",
}
type DirectionVal = keyof typeof Direction;

class Point {
    public x = 0;
    public y = 0;
    public visited = 1;

    constructor(x?: number, y?: number) {
        this.x = x || 0;
        this.y = y || 0;
    }

    public toString() {
        return `${this.x},${this.y}`;
    }
}

class LocationMap extends Map<
    ReturnType<(typeof Point)["toString"]>,
    { visited: number }
> {}

function move(x: number, y: number, locationMap: LocationMap) {
    const pt = new Point(x, y);
    if (!locationMap.has(pt.toString())) {
        locationMap.set(pt.toString(), { visited: pt.visited });
    } else {
        locationMap.get(pt.toString())!.visited++;
    }
}

(function main() {
    const locationMap = new LocationMap();
    const point = new Point(0, 0);
    locationMap.set(point.toString(), { visited: point.visited });
    let x = 0;
    let y = 0;
    for (const direction of fileText.split("") as DirectionVal[]) {
        // for (const direction of example.split("") as DirectionVal[]) {
        if (direction === DirectionName.east) {
            x += 1;
            y += 0;
            move(x, y, locationMap);
        } else if (direction === DirectionName.west) {
            x -= 1;
            y += 0;
            move(x, y, locationMap);
        } else if (direction === DirectionName.north) {
            x -= 0;
            y += 1;
            move(x, y, locationMap);
        } else if (direction === DirectionName.south) {
            x -= 0;
            y -= 1;
            move(x, y, locationMap);
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

(function main2() {
    let answer2 = 0;
    let x_santa = 0;
    let y_santa = 0;
    let x_robo = 0;
    let y_robo = 0;
    const santaMap = new LocationMap();
    const roboMap = new LocationMap();

    const point = new Point(0, 0);
    santaMap.set(point.toString(), { visited: point.visited });
    roboMap.set(point.toString(), { visited: point.visited });

    // santa goes first then robo santa
    let i = 0;
    for (const direction of fileText.split("") as DirectionVal[]) {
        // for (const direction of example.split("") as DirectionVal[]) {
        const turn = i % 2; // 0 for santa, 1 for robo
        if (turn === 0) {
            // santa turn
            if (direction === DirectionName.east) {
                x_santa += 1;
                y_santa += 0;
                move(x_santa, y_santa, santaMap);
            } else if (direction === DirectionName.west) {
                x_santa -= 1;
                y_santa += 0;
                move(x_santa, y_santa, santaMap);
            } else if (direction === DirectionName.north) {
                x_santa -= 0;
                y_santa += 1;
                move(x_santa, y_santa, santaMap);
            } else if (direction === DirectionName.south) {
                x_santa -= 0;
                y_santa -= 1;
                const pt = new Point(x_santa, y_santa);
                move(x_santa, y_santa, santaMap);
            }
        } else {
            // robo turn
            if (direction === DirectionName.east) {
                x_robo += 1;
                y_robo += 0;
                const pt = new Point(x_robo, y_robo);
                move(x_robo, y_robo, roboMap);
            } else if (direction === DirectionName.west) {
                x_robo -= 1;
                y_robo += 0;
                const pt = new Point(x_robo, y_robo);
                move(x_robo, y_robo, roboMap);
            } else if (direction === DirectionName.north) {
                x_robo -= 0;
                y_robo += 1;
                const pt = new Point(x_robo, y_robo);
                move(x_robo, y_robo, roboMap);
            } else if (direction === DirectionName.south) {
                x_robo -= 0;
                y_robo -= 1;
                const pt = new Point(x_robo, y_robo);
                move(x_robo, y_robo, roboMap);
            }
        }
        i++;
    }

    const santaEntries = santaMap.entries();
    const roboEntries = roboMap.entries();

    const visited = new Set<string>();

    for (let i = 0; i < santaMap.size; i++) {
        const santaEntry = santaEntries.next().value;
        visited.add(santaEntry[0]);
    }
    for (let i = 0; i < roboMap.size; i++) {
        const roboEntry = roboEntries.next().value;
        visited.add(roboEntry[0]);
    }

    answer2 = visited.size;
    console.log("ANSWER PART 2", answer2);
})();
