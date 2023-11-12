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

# wire connections can provide its signal to multiple destinations
class Connections {
    
}
class Heap {
    [System.Collections.Hashtable]
    $storage = @{};

    AddVar([string]$var) {
        $this.storage[$var] = 0;
    }
}
# bitwise operators
<#
-band	Bitwise AND	10 	
-bor	Bitwise OR (inclusive)		
-bxor	Bitwise OR (exclusive)		
-bnot	Bitwise NOT	 	
-shl	Shift-left	
-shr	Shift-right	
#>

class Op {
    [string]
    $name = ""

    [string]
    $operator = ""

    Op([string]$name, [string]$operator) {
        $this.name = $name;
        $this.operator = $operator;
    }
}
class Ops {
    [Op]
    $AND = [Op]::new("AND", "-band")
    [Op]
    $OR = [Op]::new("OR", "-bor")
    [Op]
    $LSHIFT = [Op]::new("LSHIFT", "-shl")
    [Op]
    $RSHIFT = [Op]::new("RSHIFT", "-shr")
    [Op]
    $NOT = [Op]::new("NOT", "-bnot")
}

Function IsDirectAssignment {
    [OutputType([bool])]
    param(
        [string]$line
    )
    $result = $false;

    $tokens = $line.Split(" ");

    if ($tokens[0] -match "\d" -and $tokens[1] -match "->") {
        $result = $true;
    }

    elseif ($tokens[0] -cmatch "^[a-z]*" -and $tokens[1] -match "->") {
        $result = $true;
    }

    return $result;
}

Function HasOperatorInLine {
    [OutputType([bool])]
    param(
        [string]$line
    )
    
    [System.Array]
    $opNames = @("AND", "OR", "LSHIFT", "RSHIFT", "NOT");
    
    [bool]
    $result = $false;

    $tokens = $line.Split(" ");

    foreach ($t in $tokens) {
        [string]$token = $t;

        if ($token -in $opNames) {
            $result = $true;
            break;
        }
    }
    return $result;
}

Function PartOne {
    [Ops]$ops = [Ops]::new();
    [Heap]$heap = [Heap]::new();

    foreach ($_line in $lines) {
        [string]$line = $_line;
        
        $tokens = $line.Split(" ");

        foreach ($token in $tokens) {
            if ($token -cmatch "^[a-z]*$") {
                if ($null -eq $heap[$token]) {
                    $heap.AddVar($token);
                }
            }
        }
    }

    # foreach ($key in $heap.storage.Keys) {
    #     Write-Host "$($key): $($heap.storage[$key])" -ForegroundColor Green
    # }

    # parse the lines after filling up the heap
    foreach ($_line in $lines) {
        [string]$line = $_line;

        $tokens = $line.Split(" ");

        # assign value to variable
        # if a direct assignment instruction
        if (IsDirectAssignment($line)) {
            $heap.storage[$tokens[2]] = [uint16]($tokens[0]);
            # break;
        }

        if (HasOperatorInLine($line)) {
            $op = $line.Split(" ") | Where-Object {
                $_ -match "AND|OR|NOT|LSHIFT|RSHIFT"
            }
            # Write-Host $op;

            #check which op it is and then do the calculation
            switch ($op) {
                "$($ops.AND.name)" {
                    $result = $heap.storage[$tokens[0]] -band $heap.storage[$tokens[2]]
                    $heap.storage[$tokens[4]] = $result;
                    break;
                }
                "$($ops.OR.name)" {
                    $result = $heap.storage[$tokens[0]] -bor $heap.storage[$tokens[2]]
                    $heap.storage[$tokens[4]] = $result;
                    break;
                }
                "$($ops.RSHIFT.name)" {
                    $result = $heap.storage[$tokens[0]] -shr $heap.storage[$tokens[2]]
                    $heap.storage[$tokens[4]] = $result;
                    break;
                }
                "$($ops.LSHIFT.name)" {
                    $result = $heap.storage[$tokens[0]] -shl $heap.storage[$tokens[2]]
                    $heap.storage[$tokens[4]] = $result;
                    break;
                }
                "$($ops.NOT.name)" {
                    $result = -bnot $heap.storage[$tokens[1]];
                    $result = [uint16]::MaxValue + $result + 1;
                    $heap.storage[$tokens[3]] = $result;
                    break;
                }
            }
        }

    }

    foreach ($key in $heap.storage.Keys) {
        Write-Host "$($key): $($heap.storage[$key])" -ForegroundColor Green
    }

    Write-Host "$($heap.storage["a"])" -ForegroundColor Green

    $answer1 = $heap.storage["a"];
    Write-Host "[INFO]: solving part one..." -ForegroundColor Cyan
    Write-Host "[INFO]: part one answer is $answer1" -ForegroundColor Green
}
Function PartTwo {
    Write-Host "[INFO]: solving part two..." -ForegroundColor Cyan
    Write-Host "[INFO]: part two answer is $answer2" -ForegroundColor Green
}

PartOne
PartTwo
