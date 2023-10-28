param(
    [Parameter(Mandatory = $true, HelpMessage = "Please enter an input filename")]
    [System.String]$InputFilename
)

[String]$answer1 = "answer goes here"
[String]$answer2 = "answer goes here"
[String]$myInput = ""

. $PSScriptRoot\..\ReadInput.ps1
. $PSScriptRoot\..\ParseLines.ps1

$myInput = Read-Input $InputFilename $PSScriptRoot
$lines = Get-InputLines $myInput


class Env {
    [System.Char]$OpenBracket = "(";
    [System.Char]$CloseBracket = ")";
    [System.Collections.ArrayList]$stack = @();
    [System.Int32]$Floor = 0;
    [System.String]$building = $($lines[0]);

    [System.Void]
    CheckFloor([char]$bracket) {
        if ($bracket -eq $this.OpenBracket) {
            $this.Floor += 1;
            $this.stack.Add($bracket) | Out-Null;
        }
        elseif ($bracket -eq $this.CloseBracket) {
            
        }
    }

}

Function PartOne {
    Write-Host "[INFO]: solving part one..." -ForegroundColor Cyan
    Write-Host "[INFO]: part one answer is $answer1" -ForegroundColor Green
}
Function PartTwo {
    Write-Host "[INFO]: solving part two..." -ForegroundColor Cyan
    Write-Host "[INFO]: part two answer is $answer2" -ForegroundColor Green
}

PartOne
PartTwo
