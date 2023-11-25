param(
    $DayNumber = 0
)

if (-not (Test-Path ".\dist")) {
    node ./node_modules/typescript/bin/tsc;
    node $(if (0 -ne $DayNumber) { "./dist/Day$DayNumber/index.js" } else { "./dist/index.js" })
}
else {
    node $(if (0 -ne $DayNumber) { "./dist/Day$DayNumber/index.js" } else { "./dist/index.js" })
}