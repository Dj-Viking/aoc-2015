param(
    [Parameter(Mandatory = $true, HelpMessage = "Please enter a day number from 1-25")]
    [System.String]$DayNumber
)

. .\Helpers.ps1;

try {
    # SOLVE FILE HERE
    $file = ".\Day$DayNumber\Day$DayNumber.ps1";
    $arguments = "-InputFilename $($InputFilename)";
    & "$file";
}
catch {
    Handle-Error($_);
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
    Write-Host "[INFO]: solve complete" -ForegroundColor Cyan
}