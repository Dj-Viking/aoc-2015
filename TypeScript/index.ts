const { day3Input: fileText_ } = require("./lib");

let fileText: string = fileText_;
let example: string = "^>v<";
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

(function main() {
    const locationMap = new Map<
        ReturnType<(typeof Point)["toString"]>,
        { visited: number }
    >();
    const point = new Point(0, 0);
    locationMap.set(point.toString(), { visited: point.visited });
    let x = 0;
    let y = 0;
    for (const direction of fileText.split("") as DirectionVal[]) {
        // for (const direction of example.split("") as DirectionVal[]) {
        if (direction === DirectionName.east) {
            x += 1;
            y += 0;
            const pt = new Point(x, y);
            if (!locationMap.has(pt.toString())) {
                locationMap.set(pt.toString(), { visited: pt.visited });
            } else {
                locationMap.get(pt.toString())!.visited++;
            }
        } else if (direction === DirectionName.west) {
            x -= 1;
            y += 0;
            const pt = new Point(x, y);
            if (!locationMap.has(pt.toString())) {
                locationMap.set(pt.toString(), { visited: pt.visited });
            } else {
                locationMap.get(pt.toString())!.visited++;
            }
        } else if (direction === DirectionName.north) {
            x -= 0;
            y += 1;
            const pt = new Point(x, y);
            if (!locationMap.has(pt.toString())) {
                locationMap.set(pt.toString(), { visited: pt.visited });
            } else {
                locationMap.get(pt.toString())!.visited++;
            }
        } else if (direction === DirectionName.south) {
            x -= 0;
            y -= 1;
            const pt = new Point(x, y);
            if (!locationMap.has(pt.toString())) {
                locationMap.set(pt.toString(), { visited: pt.visited });
            } else {
                locationMap.get(pt.toString())!.visited++;
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
