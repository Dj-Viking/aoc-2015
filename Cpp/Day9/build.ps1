param(
    [switch]$run
)
Function MyClean {
    [OutputType([System.Void])]
    param()

    if (Test-Path -Path "$($PSScriptRoot)/dist") {
        Get-ChildItem -Path "$($PSScriptRoot)/dist" | Where-Object {
            $_.FullName -match ".obj" `
                -or $_.FullName -match ".pdb" `
                -or $_.FullName -match ".idb" `
                -or $_.FullName -match ".ilk"
        } | ForEach-Object {
            Remove-Item $_.FullName;
        }
    }

}
try {

    if ($env:OS -match "Windows") {

        MyClean;

        Push-Location src;

        cmd /s /v /c "build.bat";

        if ($LASTEXITCODE -ne 0) {
            throw "code compiling/linking failed with exit code => $LASTEXITCODE";
        }
        elseif ($LASTEXITCODE -gt 0) {
            Write-Host "[INFO]: last exit code $LASTEXITCODE" -ForegroundColor Yellow;
        }
        elseif ($LASTEXITCODE -eq 0) {
            Write-Host "[INFO]: last exit code $LASTEXITCODE" -ForegroundColor Green;
            Write-Host "";
            Write-Host "";
            Write-Host "";
        }


        Pop-Location;

        if ($run) {
            & "$($PSScriptRoot)/dist/main.exe";
        }
    }
    else {
        # build somehow in another OS here assuming someone else has powershell installed
    }
}
catch {
    Write-Host "[ERROR]: $_" -ForegroundColor Red;
    Pop-Location
}