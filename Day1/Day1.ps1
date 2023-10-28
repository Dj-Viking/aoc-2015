param(
    [Parameter(
        Position = 0,
        Mandatory = $true, 
        HelpMessage = "Please enter an input filename")]
    [System.String]$InputFilename
)

[String]$answer1 = "answer goes here"
[String]$answer2 = "answer goes here"
[String]$myInput = ""

Write-Host "what is input filename $($InputFilename)"

. $PSScriptRoot\..\ReadInput.ps1
. $PSScriptRoot\..\ParseLines.ps1

$myInput = Read-Input $InputFilename $PSScriptRoot


class Env {
    [System.Char]$OpenBracket = "(";
    [System.Char]$CloseBracket = ")";
    [System.Int32]$Floor = 0;
    [System.String]$building = $($myInput);

    [System.Void]
    CheckFloor([char]$bracket) {
        if ($bracket -eq $this.OpenBracket) {
            $this.Floor += 1;
        }
        elseif ($bracket -eq $this.CloseBracket) {
            $this.Floor -= 1;
        }
    }

}

$problem = [Env]::new();

Function PartOne {

    for ($i = 0; $i -lt $problem.building.Length; $i++) {
        $problem.CheckFloor($problem.building[$i]);
    }

    Write-Host "floor $($problem.Floor)";

    Write-Host "[INFO]: solving part one..." -ForegroundColor Cyan
    Write-Host "[INFO]: part one answer is $answer1" -ForegroundColor Green
}
Function PartTwo {
    Write-Host "[INFO]: solving part two..." -ForegroundColor Cyan
    Write-Host "[INFO]: part two answer is $answer2" -ForegroundColor Green
}

PartOne
PartTwo
