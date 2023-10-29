if (-not (Test-Path ".\dist")) {
    node ./node_modules/typescript/bin/tsc;
    node ./dist/index.js
}
else {
    node ./dist/index.js
}