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
# make heap key values point to other keyvalues via [ref] types 
class Heap {
    [System.Collections.Hashtable]
    $storage = @{};
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

# 123 -> x
Function IsProvidingValueToWire {
    [OutputType([bool])]
    param(
        [string]$line
    )

    [bool]$result = $false;

    $tokens = $line.Split(" ");

    if ($tokens[0] -cmatch "\d" -and $tokens[1] -match "->") {
        $result = $true;
    }

    return $result;
}
# lx -> a
Function IsConnectingTwoWires {
    [OutputType([bool])]
    param(
        [string]$line
    )
    [bool]$result = $false;
    $tokens = $line.Split(" ");

    if ($tokens[0] -cmatch "^[a-z]*$" -and $tokens[1] -match "->") {
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

Function IsReferenceType {
    [OutputType([bool])]
    param(
        $variable
    )
    $result = $false;
    if ($variable.GetType().Name.Contains("Reference")) {
        $result = $true;
    }
    return $result;
}

[System.Collections.ArrayList]$operationsLines = @();
[System.Collections.ArrayList]$valueToWireList = @();
[System.Collections.ArrayList]$connectingTwoWiresList = @();

Function PartOne {
    [Ops]$ops = [Ops]::new();
    [Heap]$heap = [Heap]::new();

    foreach ($l in $lines) {
        [string]$line = $l;
        # something is fucked up with powershell functions 
        # the only result I care about is for some reason 
        # the last item in a fucking returned array!!!
        $hasop = $(HasOperatorInLine($line))[-1];
        $isconnecting = $(IsConnectingTwoWires($line))[-1];
        $isprovidingvalue = $(IsProvidingValueToWire($line))[-1];
        if ($hasop -eq $true) {
            $operationsLines.Add($line) | Out-Null;
        }
        elseif ($isconnecting -eq $true) {
            $connectingTwoWiresList.Add($line) | Out-Null;
        }
        elseif ($isprovidingvalue -eq $true) {
            $valueToWireList.Add($line) | Out-Null;
        }

    }
    
    # create heap
    foreach ($l in $lines) {
        [string]$line = $l;

        $tokens = $line.Split(" ");

        foreach ($t in $tokens) {
            [string]$token = $t;

            if ($token -cmatch "^[a-z]*$") {
                if ($null -eq $heap.storage[$token]) {
                    $heap.storage[$token] = 0;
                }
            }
        }
    }

    #make connections
    foreach ($instr in $connectingTwoWiresList) {
        [string]$instr = $instr;
        $tokens = $instr.Split(" ");
        $heap.storage[$tokens[0]] = [ref]($heap.storage[$tokens[0]]);
        $heap.storage[$tokens[2]] = $heap.storage[$tokens[0]];
    }

    # assign values to whom are instructed to be assigned values
    foreach ($l in $valueToWireList) {
        [string]$line = $l;

        $tokens = $line.Split(" ");

        $value = $tokens[0];
        $var = $tokens[2];

        $heap.storage[$var] = [uint16]($value);
    }

    # parse operations
    foreach ($line in $operationsLines) {
        [string]$line = $line;

        $tokens = $line.Split(" ");

        $op = $line.Split(" ") | Where-Object {
            $_ -match "AND|OR|LSHIFT|RSHIFT|NOT"
        };

        # if the value getting assigned is a reference type
        # then might have some pointing issues later...
        # not sure yet.
        switch ($op) {
            "$($ops.AND.name)" {
                $result = $heap.storage[$tokens[0]] -band $heap.storage[$tokens[2]]
                [bool]$isRef = $(IsReferenceType($heap.storage[$tokens[4]])[-1]);
                if ($isRef) {
                    $heap.storage[$tokens[4]].Value = $result;
                }
                else {
                    $heap.storage[$tokens[4]] = $result;
                }
                break;
            }
            "$($ops.OR.name)" {
                $result = $heap.storage[$tokens[0]] -bor $heap.storage[$tokens[2]]
                [bool]$isRef = $(IsReferenceType($heap.storage[$tokens[4]])[-1]);
                if ($isRef) {
                    $heap.storage[$tokens[4]].Value = $result;
                }
                else {
                    $heap.storage[$tokens[4]] = $result;
                }
                break;
            }
            "$($ops.RSHIFT.name)" {
                $result = $heap.storage[$tokens[0]] -shr $heap.storage[$tokens[2]]
                [bool]$isRef = $(IsReferenceType($heap.storage[$tokens[4]])[-1]);
                if ($isRef) {
                    $heap.storage[$tokens[4]].Value = $result;
                }
                else {
                    $heap.storage[$tokens[4]] = $result;
                }
                break;
            }
            "$($ops.LSHIFT.name)" {
                $result = $heap.storage[$tokens[0]] -shl $heap.storage[$tokens[2]]
                [bool]$isRef = $(IsReferenceType($heap.storage[$tokens[4]])[-1]);
                if ($isRef) {
                    $heap.storage[$tokens[4]].Value = $result;
                }
                else {
                    $heap.storage[$tokens[4]] = $result;
                }
                break;
            }
            "$($ops.NOT.name)" {
                $result = -bnot $heap.storage[$tokens[1]];
                $result = [uint16]::MaxValue + $result + 1;
                [bool]$isRef = $(IsReferenceType($heap.storage[$tokens[3]])[-1]);
                if ($isRef) {
                    $heap.storage[$tokens[3]].Value = $result;
                }
                else {
                    $heap.storage[$tokens[3]] = $result;
                }
                break;
            }
        }
    }

    

    Write-Host "[INFO]: solving part one..." -ForegroundColor Cyan
    Write-Host "[INFO]: part one answer is $answer1" -ForegroundColor Green
}
Function PartTwo {
    Write-Host "[INFO]: solving part two..." -ForegroundColor Cyan
    Write-Host "[INFO]: part two answer is $answer2" -ForegroundColor Green
}

PartOne
PartTwo
