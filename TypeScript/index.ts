import fs from "fs";
const fileText = fs.readFileSync("input.txt", { encoding: "utf-8" });

enum Direction {
    north = "north",
    south = "south",
    east = "east",
    west = "west",
}
class NorthPole {
    // present delivered at start
    public presentsDelivered = 1;
    public previousDirection: null | Direction = null;
    public housepath: string = fileText;
    public pathArray: string[] = [];

    constructor() {
        this.pathArray = this.housepath.split("");
    }

    public main() {
        console.log("hello north pole", this.pathArray);
    }
}

const northpole = new NorthPole();

northpole.main();
