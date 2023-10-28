Function Handle-Error {
    param(
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.ErrorRecord]$e
    )

    $tab = [char]9;

    Write-Host "[ERROR]: some error happened here $($e.ErrorDetails)";
    Write-Host "[ERROR]: $($tab) $($e.ErrorDetails)";
    Write-Host "[ERROR]: $($tab) $($tab) Exception => $($e.Exception)";
    Write-Host "[ERROR]: $($tab) $($tab) Stack Trace => $($e.ScriptStackTrace)";
}