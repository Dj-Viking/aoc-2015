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


class Stack {
    [System.Collections.ArrayList]
    $storage = @();

    #Region stack methods
    [Void]
    Push($item) {
        $this.storage.Add($item) | Out-Null;
    }

    [System.Char]
    Pop() {
        $lastItem = $this.storage[-1];
        $this.storage[-1] = $null;
        return $lastItem;
    }

    [System.Char]
    Peek() {
        return $this.storage[-1];
    }

    [System.Int64]
    Size() {
        return $this.storage.Count;
    }
    #EndRegion
}

class Santa {

    #Region props
    [System.Char]
    $OpenBracket = "(";
    
    [System.Char]
    $CloseBracket = ")";

    [System.Collections.Hashtable]
    $matching = 
    @{
        "(" = ")"
    }
    
    [System.Int32]
    $Floor = 1;
    
    [System.String]
    $building = $($myInput);
    
    [Stack]
    $parseStack = [Stack]::new();
    #EndRegion
    
    #Region santa methods
    [System.Void]
    CheckFloor([char]$bracket, [System.Int64]$position) {
        if ($bracket -eq $this.OpenBracket) {
            $this.parseStack.Push($bracket);
        }
    }

    [System.Void]
    Debug() {
        Write-Host $($this.parseStack);
    }
    #EndRegion

}

$santa = [Santa]::new();

Function PartOne {

    for ($position = 0; $position -lt $santa.building.Length; $position++) {
        $bracket = $santa.building[$position];

        Write-Host "floor before move $($santa.Floor) position: $($position + 1) char $($bracket)";
        $santa.CheckFloor($bracket, $position);
        Write-Host "floor after  move $($santa.Floor) position: $($position + 1) char $($bracket)" -ForegroundColor Cyan;
    }


    Write-Host "floor $($santa.Floor)";

    Write-Host "[INFO]: solving part one..." -ForegroundColor Cyan
    Write-Host "[INFO]: part one answer is $answer1" -ForegroundColor Green
}
Function PartTwo {

    Write-Host "[INFO]: solving part two..." -ForegroundColor Cyan
    Write-Host "[INFO]: part two answer is $answer2" -ForegroundColor Green
}

PartOne
# PartTwo
