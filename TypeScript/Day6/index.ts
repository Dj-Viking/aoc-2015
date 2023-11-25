import { readFileSync } from "fs";

const input1 = readFileSync(__dirname + "\\input.txt", { encoding: "utf-8" });
const instructions1 = input1.split("\r\n");
const input2 = readFileSync(__dirname + "\\input2.txt", { encoding: "utf-8" });
const instructions2 = input2.split("\r\n");
console.log(instructions2);

type Status = boolean;

class LED {
    public x: number = 0;
    public y: number = 0;
    public status: Status = false;

    public constructor(x: number, y: number) {
        this.x = x;
        this.y = y;
    }
}

const LEDGrid: LED[][] = [];

// const GRID_SIZE = 11;
const GRID_SIZE = 1001;

for (let y = 0; y < GRID_SIZE; y++) {
    LEDGrid.push([]); //row
    for (let x = 0; x < GRID_SIZE; x++) {
        // add columns to row
        LEDGrid[y].push(new LED(x, y));
    }
    LEDGrid[y].pop();
}

// console.log(LEDGrid);

LEDGrid.pop();

let answer1 = null;
let answer2 = null;

type Action = "on" | "off" | "toggle";

function applyInstruction(line: string) {
    const action: Action = line
        .split(" ")
        .find((item) => /on|off|toggle/g.test(item)) as Action;

    console.log("what is action => ", action);

    let areainstr: string[] = [];

    if (line.includes("on") || line.includes("off")) {
        const splitLine = line.split(" ");
        areainstr = [`${splitLine[2]}`, `${splitLine[3]}`, `${splitLine[4]}`];
    } else {
        // includes toggle
        const splitLine = line.split(" ");
        areainstr = [`${splitLine[1]}`, `${splitLine[2]}`, `${splitLine[3]}`];
    }

    console.log("what is areainstr => ", areainstr);

    const lhArea = areainstr[0];
    const rhArea = areainstr[2];

    const rowStart: number = Number(lhArea.split(",")[0]);
    const colStart: number = Number(lhArea.split(",")[1]);
    const rowEnd: number = Number(rhArea.split(",")[0]);
    const colEnd: number = Number(rhArea.split(",")[1]);

    const rowRange: number = rowEnd - rowStart;
    const columnRange: number = colEnd - colStart;

    console.log("row range => ", rowRange, "\n", "col range => ", columnRange);

    for (let row = rowStart; row <= rowEnd; row++) {
        for (let col = colStart; col <= colEnd; col++) {
            switch (action) {
                case "on":
                    {
                        LEDGrid[col][row].status = true;
                    }
                    break;
                case "off":
                    {
                        LEDGrid[col][row].status = false;
                    }
                    break;
                case "toggle":
                    {
                        LEDGrid[col][row].status = !LEDGrid[col][row].status;
                    }
                    break;
            }
            // console.log(LEDGrid[col][row]);
        }
    }
}

(function main() {
    // for (const instr of instructions2) {
    //     applyInstruction(instr);
    // }
    for (const instr of instructions1) {
        applyInstruction(instr);
    }

    let count = 0;
    for (let i = 0; i < LEDGrid.length; i++) {
        for (let j = 0; j < LEDGrid[0].length; j++) {
            if (LEDGrid[i][j].status) count++;
        }
    }

    answer1 = count;

    console.log("answer1 is", answer1);
})();
(function main2() {
    console.log("answer2 is", answer2);
})();
