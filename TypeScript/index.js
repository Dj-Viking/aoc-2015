"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = __importDefault(require("fs"));
const fileText = fs_1.default.readFileSync("input.txt", { encoding: "utf-8" });
var Direction;
(function (Direction) {
    Direction["north"] = "north";
    Direction["south"] = "south";
    Direction["east"] = "east";
    Direction["west"] = "west";
})(Direction || (Direction = {}));
class NorthPole {
    constructor() {
        // present delivered at start
        this.presentsDelivered = 1;
        this.previousDirection = null;
        this.housepath = fileText;
        this.pathArray = [];
        this.pathArray = this.housepath.split("");
    }
    main() {
        console.log("hello north pole", this.pathArray);
    }
}
const northpole = new NorthPole();
northpole.main();
