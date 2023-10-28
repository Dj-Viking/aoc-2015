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

Write-Host "what is input filename $($InputFilename)";

. $PSScriptRoot\..\ReadInput.ps1;
. $PSScriptRoot\..\ParseLines.ps1;

$myInput = Read-Input $InputFilename $PSScriptRoot;

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
    $input = $($myInput);

    [System.Collections.ArrayList]
    $building = $( & {
            $arrlist = [System.Collections.ArrayList]@();
            foreach ($char in $myInput.ToCharArray()) {
                $arrlist.Add($char) | Out-Null;
            }
            return $arrlist;
        });
    
    #EndRegion
    

}


Function PartOne {

    $santa = [Santa]::new();


    for ($i = 0; $i -lt $santa.building.Count; $i++) {

        $bracket = $santa.building[$i];
        if ($bracket -eq $santa.OpenBracket) {
            $santa.Floor += 1;
        }
        if ($bracket -eq $santa.CloseBracket) {
            $santa.Floor -= 1;
        }

    }

    $answer1 = $santa.Floor - 1;

    Write-Host "[INFO]: solving part one..." -ForegroundColor Cyan
    Write-Host "[INFO]: part one answer is $answer1" -ForegroundColor Green
}
Function PartTwo {

    $santa = [Santa]::new();

    Write-Host "what is santa $santa";

    $santaposition = 0;

    for ($position = 0; $position -lt $santa.building.Count; $position++) {
        $bracket = $santa.building[$position];

        # Write-Host "floor before move $($santa.Floor) position: $($position + 1) char $($bracket)";
        
        if ($bracket -eq $santa.OpenBracket) {
            $santa.Floor += 1;
        }
        if ($bracket -eq $santa.CloseBracket) {
            
            $santa.Floor -= 1;

            if ($santa.Floor -eq -1) {
                $santaposition = $position;
                break;
            }

        }

        # Write-Host "floor after  move $($santa.Floor) position: $($position + 1) char $($bracket)" -ForegroundColor Cyan;
    }

    Write-Host "[INFO]: solving part two..." -ForegroundColor Cyan
    Write-Host "[INFO]: part two answer is $santaposition" -ForegroundColor Green
}

PartOne
PartTwo
