param(
    [Parameter(Mandatory = $true, HelpMessage = "Please enter a day number from 1-25")]
    [System.String]$DayNumber,
    [Parameter(Mandatory = $true, HelpMessage = "Please enter a day number from 1-25")]
    [System.String]$InputFilename
)

. .\Helpers.ps1;

try {
    # SOLVE FILE HERE
    $file = ".\Day$DayNumber\Day$DayNumber.ps1";
    powershell -NoProfile -ExecutionPolicy Bypass -File "$file" -Inputfilename $InputFilename
}
catch {
    Handle-Error($_);
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
    Write-Host "[INFO]: solve complete" -ForegroundColor Cyan
}