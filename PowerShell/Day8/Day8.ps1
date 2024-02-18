param(
    [Parameter(Mandatory = $true, HelpMessage = "Please enter an input filename")]
    [System.String]$InputFilename
)

[String]$answer1 = "answer goes here"
[String]$answer2 = "answer goes here"
[String]$myInput = ""

. $PSScriptRoot\..\ReadInput.ps1
. $PSScriptRoot\..\ParseLines.ps1

$lines = Get-Content -Path "$PSScriptRoot\$InputFilename.txt"

Function Get-CharAmountInMemory {
    [OutputType([int])]
    param(
        [string]$line
    )

    . {
        [int]$in_mem_amount = 0;
        
        for ($i = 0; $i -lt $line.Length; $i++) {
    
            $asciiCode = [int]([char]$line[$i]);
            if ($asciiCode -eq 34 -and ($i -eq 0 -or $i -eq ($line.Length - 1))) {
                continue;
            }
            else {
                # branch if \\
                if ($asciiCode -eq 92 -and [int]([char]$line[$i + 1]) -eq 92) {
                    $in_mem_amount += 1;
                    $i += 1;
                    continue;
                }
                # branch if \ in string and next char is not x
                if ($asciiCode -eq 92 -and [int]([char]$line[$i + 1]) -ne 120) {
                    # get next char after this to check if it's a hex escape or another escaped character to add in memory
                    $in_mem_amount += 1;
                    $i += 1;
                    continue;
                } # branch again if \x(num)(num)
                elseif ($asciiCode -eq 92 -and [int]([char]$line[$i + 1]) -eq 120) {
                    $in_mem_amount += 1;
                    $i += 3;
                    continue;
                }
                $in_mem_amount += 1;
            }
        }
    } | Out-Null;

    return $in_mem_amount;

}


Function PartOne {
    
    [System.Collections.ArrayList]$charAmountList = [System.Collections.ArrayList]@();
    [System.Collections.ArrayList]$inMemAmountList = [System.Collections.ArrayList]@();

    foreach ($line in $lines) {
        # Write-Host "line => $line" -ForegroundColor Green;
        # Write-Host "line length $($line.Length)"
        $charAmountList.Add($line.Length) | Out-Null;
        $inMem = Get-CharAmountInMemory -line $line;
        $inMemAmountList.Add($inMem) | Out-Null;
        # Write-Host "in mem amount => $inMem" -ForegroundColor Cyan;
        
    }
    $charSum = 0;
    $inMemSum = 0;

    foreach ($num in $charAmountList) {
        $charSum += $num;
    }
    foreach ($num in $inMemAmountList) {
        $inMemSum += $num;
    }

    # Write-Host "char sum $charSum - inmem sum $inMemSum" -ForegroundColor Magenta;

    $answer1 = $charSum - $inMemSum;

    # 1448 is TOO HIGH!!!!!!
    
    Write-Host "[INFO]: solving part one..." -ForegroundColor Cyan
    Write-Host "[INFO]: part one answer is $answer1" -ForegroundColor Green
}

Function Get-EncodedStrFromStr {
    [OutputType([string])]
    param(
        [string]$line
    )

    . {
        [string]$newstr = "`"";
        [string]$encode = "\"
        for ($i = 0; $i -lt $line.Length; $i++) {
            if ($line[$i] -match "\\" -or $line[$i] -match "`"") {
                $newstr += $encode
            }
            $newstr += $line[$i];
        }

        $chararr = $newstr.ToCharArray();

        $chararr[-1] = "`"";
        $chararr += "`"";

        $newstr = $chararr -join "";

    } | Out-Null;

    return $newstr;
}
Function PartTwo {

    # encode the line into a new string including the surrounding quotes at the beginning and the enda

    [System.Collections.ArrayList]$charAmountList = [System.Collections.ArrayList]@();
    [System.Collections.ArrayList]$encodedCharAmountList = [System.Collections.ArrayList]@();

    foreach ($line in $lines) {

        $charAmountList.Add($line.Length) | Out-Null;
        $encodedStr = Get-EncodedStrFromStr -line $line;
        # Write-Host "encoded str $encodedStr - length $($encodedStr.Length)" -ForegroundColor Magenta;
        $encodedCharAmountList.Add($encodedStr.Length) | Out-Null;
        
    }


    $charSum = 0;
    $encCharSum = 0;
    foreach ($num in $charAmountList) {
        $charSum += $num;
    }
    foreach ($num in $encodedCharAmountList) {
        $encCharSum += $num;
    }

    $answer2 = $encCharSum - $charSum;

    Write-Host "[INFO]: solving part two..." -ForegroundColor Cyan
    Write-Host "[INFO]: part two answer is $answer2" -ForegroundColor Green
}

PartOne
PartTwo
