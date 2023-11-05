import * as liveserver from "live-server";

const home = process.env.HOME;

liveserver.start({
    file: `${home}/projects/aoc-2015/TypeScript/dist/Day6/index.html`,
    port: 6969,
    open: true,
});
