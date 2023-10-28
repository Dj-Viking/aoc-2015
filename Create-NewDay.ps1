param(
    [Parameter(Mandatory = $true, HelpMessage = "Please enter a DayNumber value for the first parameter")]
    [System.Int16]
    $DayNumber
)

. .\Helpers.ps1;

try {
    
    Write-Host "[INFO]: creating a folder for day $($DayNumber)..." -ForegroundColor Green;
    
    Write-Host "[INFO]: Creating powershell project for new day" -ForegroundColor Green;
    
    $result = sh "$($PSScriptRoot)/boilerplate.sh" $DayNumber

    Write-Host "what was the result of calling sh [$($result)]" -ForegroundColor Magenta;
}
catch { Handle-Error($err); }
finally {
    Write-Host "[INFO]: create new day done" -ForegroundColor Cyan;
    Write-Host "[INFO]: done creating starter powershell day~~~" -ForegroundColor Green
}
