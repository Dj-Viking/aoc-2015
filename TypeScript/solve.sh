set -e;

if [ -d "dist" ]; then
    node ./dist/index.js;
fi

if ! [ -z $1 ]; then
    cp ./Day6/index.html ./dist/Day6
    node ./dist/Day$1/live-server.js
fi

if ! [ -d "dist" ]; then
    node ./node_modules/typescript/bin/tsc;
    node ./dist/index.js;
fi