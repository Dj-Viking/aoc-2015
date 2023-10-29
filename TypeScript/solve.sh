if [ -d "dist" ]; then
    node ./dist/index.js;
fi

if ! [ -d "dist" ]; then
    node ./node_modules/typescript/bin/tsc;
    node ./dist/index.js;
fi