param(
    $DayNumber = 0
)

Copy-Item -Path "./Day6/input.txt" -Destination "./dist/Day6"
Copy-Item -Path "./Day6/input2.txt" -Destination "./dist/Day6"

if (-not (Test-Path ".\dist")) {
    node ./node_modules/typescript/bin/tsc;
    node $(if (0 -ne $DayNumber) { "./dist/Day$DayNumber/index.js" } else { "./dist/index.js" })
}
else {
    node $(if (0 -ne $DayNumber) { "./dist/Day$DayNumber/index.js" } else { "./dist/index.js" })
}