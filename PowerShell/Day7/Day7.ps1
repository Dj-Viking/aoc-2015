param(
    [Parameter(Mandatory = $true, HelpMessage = "Please enter an input filename")]
    [System.String]$InputFilename
)

[bool]$part1 = $false;

[String]$answer1 = "answer goes here"
[String]$answer2 = "answer goes here"
[String]$myInput = ""

. $PSScriptRoot\..\ReadInput.ps1
. $PSScriptRoot\..\ParseLines.ps1

$myInput = Read-Input $InputFilename $PSScriptRoot
$lines = Get-InputLines $myInput

class Wire {
    [bool]
    $hasSignal = $false;

    [uint16]
    $value = 0;

    [string]
    $name = "";

    Wire($name, $value) {
        $this.name = $name;
        $this.value = $value;
    }
}

class Instruction {
    [bool]
    $wasCompleted = $false;

    [string]
    $instruction = "";

    Instruction($instruction) {
        $this.instruction = $instruction;
    }
}

[System.Collections.ArrayList]$instructionList = [System.Collections.ArrayList]@();

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
[System.Array]$opNames = @("AND", "OR", "LSHIFT", "RSHIFT", "NOT");
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

    . {
        [bool]$result = $false;
    
        $tokens = $line.Split(" ");
    
        if ($tokens[0] -cmatch "\d" -and $tokens[1] -match "->") {
            $result = $true;
        }
    } | Out-Null;

    return $result;
}
# lx -> a
Function IsConnectingTwoWires {
    [OutputType([bool])]
    param(
        [string]$line
    )

    . {
        [bool]
        $result = $false;
        
        $tokens = $line.Split(" ");
    
        if ($tokens[0] -cmatch "^[a-z]*$" -and $tokens[1] -match "->" -and $tokens[2] -cmatch "^[a-z]*$") {
            $result = $true;
        }
    } | Out-Null;

    return $result;
}

Function HasOperatorInLine {
    [OutputType([bool])]
    param(
        [string]$line
    )
    
    . {
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
    } | Out-Null;

    return $result;
}

Function ExprHasValue {
    [OutputType([bool])]
    param(
        [string]$line
    )

    . {
        [bool]
        $result = $false;
    
        $tokens = $line.Split(" ");
    
        foreach ($token in $tokens) {
            if ($token -match "\d" -and $line -cmatch "AND|OR|LSHIFT|RSHIFT|NOT") {
                $result = $true;
                break;
            }
        }
    } | Out-Null;

    return $result;
}

Function OperandIsNumber {
    [OutputType([bool])]
    param(
        $operand
    )

    . {
        [bool]$result = $false;

        if ($operand -cmatch "^[a-z]*$") {
            $result = $false;
        }
        else {
            $result = $true;
        }

    } | Out-Null;

    return $result;
}

Function PerformOperationWithValue {
    [OutputType([System.Void])]
    param(
        [System.Array]
        $expr,

        [string]
        $target,

        [Ops]
        $ops,

        [Heap]
        $heap,

        [Int32]
        $index,

        [System.Collections.ArrayList]
        $instructionList,

        [switch]
        $isBinary = $false
    )


    if ($isBinary) {

    }
    else {
        $op = $expr | Where-Object { $_ -cmatch "AND|OR|NOT|RSHIFT|LSHIFT" };
    
        # 4 LSHIFT X -> y
    
        $result = Invoke-Expression "$(if (OperandIsNumber($expr[0])) {
            "[uint16]$($expr[0])"
        } else { $heap.storage[$expr[0]].value }) $($ops.$($op).operator) $(if (OperandIsNumber($expr[2])) {
            "[uint16]$($expr[2])"
        } else { $heap.storage[$expr[2]].value });";
    
        $heap.storage[$target].value = $result;
        $heap.storage[$target].hasSignal = $true;
    
        $instructionList[$index].wasCompleted = $true;
        # Write-Host "3 was COMPLETED holy fucking SHIT!!!! for this instruction $($instr.instruction) - was completed $($instr.wasCompleted)"
    }

    # Write-Host "1 was COMPLETED holy fucking SHIT!!!! for this instruction $($instructionList[$index].instruction) - was completed $($instructionList[$index].wasCompleted)"

    # switch ($op) {
    #     "$($ops.AND.name)" {
    #         $result = $expr[0] -band $heap.storage[$expr[2]].value;

    #         $heap.storage[$target].value = $result;
    #         $heap.storage[$target].hasSignal = $true;

    #         $instructionList[$index].wasCompleted = $true;

    #         break;
    #     }
    #     "$($ops.OR.name)" {
    #         $result = $expr[0] -bor $heap.storage[$expr[2]].value;

    #         $heap.storage[$target].value = $result;
    #         $heap.storage[$target].hasSignal = $true;

    #         $instructionList[$index].wasCompleted = $true;

    #         break;
    #     }
    #     "$($ops.LSHIFT.name)" {
    #         $result = $expr[0] -shl $heap.storage[$expr[2]].value;

    #         $heap.storage[$target].value = $result;
    #         $heap.storage[$target].hasSignal = $true;

    #         $instructionList[$index].wasCompleted = $true;

    #         break;
    #     }
    #     "$($ops.RSHIFT.name)" {
    #         $result = $expr[0] -shr $heap.storage[$expr[2]].value;

    #         $heap.storage[$target].value = $result;
    #         $heap.storage[$target].hasSignal = $true;

    #         $instructionList[$index].wasCompleted = $true;

    #         break;
    #     }
    # }
}

Function PerformOperation {
    [OutputType([System.Void])]
    param(
        [System.Array]
        $expr,

        [string]
        $target,

        [Ops]
        $ops,

        [Heap]
        $heap,

        [Int32]
        $index,

        [System.Collections.ArrayList]
        $instructionList,

        [switch]
        $isBinary = $false
    )

    $op = $expr | Where-Object { $_ -cmatch "AND|OR|NOT|LSHIFT|RSHIFT" }

    if ($isBinary) {
        $result = -bnot $heap.storage[$expr[1]].value;
        $result = [uint16]::MaxValue + $result + 1;

        $heap.storage[$target].value = $result;
        $heap.storage[$target].hasSignal = $true;
        $instructionList[$index].wasCompleted = $true;
        # Write-Host " 2 was COMPLETED holy fucking SHIT!!!! for this instruction $($instructionList[$index].instruction) - was completed $($instructionList[$index].wasCompleted)"

    }
    else {

        switch ($op) {
            "$($ops.AND.name)" {
                $result = $heap.storage[$expr[0]].value -band $heap.storage[$expr[2]].value;
                
                $heap.storage[$target].value = $result;
                $heap.storage[$target].hasSignal = $true;
                $instructionList[$index].wasCompleted = $true;
                break;
            }
            "$($ops.OR.name)" {
                $result = $heap.storage[$expr[0]].value -bor $heap.storage[$expr[2]].value;

                $heap.storage[$target].value = $result;
                $heap.storage[$target].hasSignal = $true;
                $instructionList[$index].wasCompleted = $true;
                break;
            }
            "$($ops.LSHIFT.name)" {
                $result = $heap.storage[$expr[0]].value -shl $heap.storage[$expr[2]].value;

                $heap.storage[$target].value = $result;
                $heap.storage[$target].hasSignal = $true;
                $instructionList[$index].wasCompleted = $true;
                break;
            }
            "$($ops.RSHIFT.name)" {
                $result = $heap.storage[$expr[0]].value -shr $heap.storage[$expr[2]].value;

                $heap.storage[$target].value = $result;
                $heap.storage[$target].hasSignal = $true;
                $instructionList[$index].wasCompleted = $true;
                break;
            }
        }
    }

}

[System.Collections.ArrayList]$operationsLines = @();
[System.Collections.ArrayList]$valueToWireList = @();
[System.Collections.ArrayList]$connectingTwoWiresList = @();
[System.Collections.ArrayList]$exprsWithValue = @();


# I think I really have to incrementally go through each expression that will 
# actually yield some change other than 0 
# because doing these bitwise operators on 0 will almost always just result in 0
# thus nothing meaningful will really happen.
# I think I have to go through which ever expressions
# for example
# 1: assigns a hard coded value to wire b
# 2: find which expressions that include wire b and only evaluate those expressions next
# 3: find which wires have values after number 2
# 4: find which expressions that include those wires and only evaluate those expressions
# 5: repeat until each expression in the input has been evaluated and remove those expressions
#    from the list of expressions that have yet to be evaluated 

# i think the key is this - gates don't provide signal to the output until
# all inputs to the gate have signal

# so if the expression is:
# x AND y -> z
# and x and y never had a signal applied to them yet..
# then the expression should not get evaluated or provide signal to z yet

Function PartOneAndTwo {
    [Ops]$ops = [Ops]::new();
    [Heap]$heap = [Heap]::new();

    if ($part1) {
        foreach ($l in $lines) {
            [string]$line = $l;
            
            $instructionList.Add([Instruction]::new($line)) | Out-Null;
    
            $hasop = $(HasOperatorInLine($line));
            $isconnecting = $(IsConnectingTwoWires($line));
            $isprovidingvalue = $(IsProvidingValueToWire($line));
            $exprHasValue = $(ExprHasValue($line));
            if ($hasop -eq $true -and $exprHasValue -eq $false) {
                $operationsLines.Add($line) | Out-Null;
            }
            elseif ($isconnecting -eq $true) {
                $connectingTwoWiresList.Add($line) | Out-Null;
            }
            elseif ($isprovidingvalue -eq $true) {
                $valueToWireList.Add($line) | Out-Null;
            }
            elseif ($exprHasValue -eq $true) {
                $exprsWithValue.Add($line)[1] | Out-Null;
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
                        $heap.storage[$token] = [Wire]::new($token, 0)
                    }
                }
            }
        }
    
        # assign values to whom are instructed to be assigned values
        foreach ($l in $valueToWireList) {
            [string]$line = $l;
    
            $tokens = $line.Split(" ");
    
            $value = $tokens[0];
            $var = $tokens[2];
    
            $heap.storage[$var].value = [uint16]($value);
            $heap.storage[$var].hasSignal = $true;
    
            for ($i = 0; $i -lt $instructionList.Count; $i++) {
                [Instruction]$instr = $instructionList[$i];
    
                if ($line -match $instr.instruction) {
                    $instructionList[$i].wasCompleted = $true;
                }
            }
        }
    
        # loop through all lines again over and over until a particular wire has signal applied to it
        do {
            for ($i = 0; $i -lt $instructionList.Count; $i++) {
                [Instruction]$instr = $instructionList[$i];
    
                # Write-Host "instr index: $i - current instr $($instr.instruction) CURRENT WAS COMPLETE $($instr.wasCompleted)" -ForegroundColor Green;
                # Write-Host "lx: $($heap.storage["lx"].value) a: $($heap.storage["a"].value)" -ForegroundColor Yellow;
    
                if ($instr.wasCompleted -eq $true) {
                    $instructionList.Remove($instr);
                    Write-Host "REMOVED SOME SHIT!!! $($instr.instruction) instruction list count now $($instructionList.Count)" -ForegroundColor Magenta;
    
                    # Write-Host "what the fuck is lx $($heap.storage["lx"].value)" -ForegroundColor Yellow;
    
                    break;
                }
    
                $tokens = $instr.instruction.Split(" ");
    
                $hasop = $(HasOperatorInLine($instr.instruction));
                $exprHasValue = $(ExprHasValue($instr.instruction));
                $isconnectingtwowires = $(IsConnectingTwoWires($instr.instruction));
                $isprovidingvalue = $(IsProvidingValueToWire($instr.instruction));
    
                if ($hasop -eq $true -and $exprHasValue -eq $false) {
    
    
                    $op = $tokens | Where-Object { $_ -cmatch "AND|NOT|LSHIFT|OR|RSHIFT" };
    
                    if ($op -cmatch "NOT") {
                        $onlyOperand = $tokens[1];
    
                        $target = $tokens[3];
    
                        $expr = @("NOT", $onlyOperand);
    
                        if ($heap.storage[$onlyOperand].hasSignal -eq $false -or $heap.storage[$target].hasSignal -eq $true) {
                            continue;
                        }
    
                        PerformOperation -expr $expr `
                            -target $target `
                            -ops $ops `
                            -heap $heap `
                            -index $i `
                            -instructionList $instructionList `
                            -isBinary;
                    }
                    else {
                        $lhoperand = $tokens[0];
        
                        $rhoperand = $tokens[2];
        
                        [Wire]$wireLeft = $heap.storage[$lhoperand];
                        [Wire]$wireRight = $heap.storage[$rhoperand];
        
                        [string]$target = $tokens[4];
        
                        if ($heap.storage[$target].hasSignal -eq $true) {
                            continue;
                        }
        
                        if ($wireLeft.hasSignal -eq $true -and `
                                $wireRight.hasSignal -eq $true -and `
                                $heap.storage[$target].hasSignal -eq $false
                        ) {
                            # Write-Host " 5 ONLY EXPR WITH VALUE like this $($instructionList[$i].instruction)"
        
                            # perform op to apply signal to the target wire
                            [System.Array]$splitInstr = $instr.instruction.Split(" -> ", [System.StringSplitOptions]::RemoveEmptyEntries);
        
                            [System.Array]$expr = @($splitInstr[0], $splitInstr[1], $splitInstr[2]);
        
                            PerformOperation -expr $expr `
                                -target $target `
                                -ops $ops `
                                -heap $heap `
                                -index $i `
                                -instructionList $instructionList;
                            
                        }
                        else {
                            continue;
                        }
                    }
    
                }
    
                #condition to perform operation on an instruction set that has a wire and a value in the left and/or right operands in the expression
                elseif ($exprHasValue -eq $true) {
    
                    $op = $tokens | Where-Object { $_ -cmatch "AND|OR|NOT|LSHIFT|RSHIFT" };
    
                    if ($op -cmatch "NOT") {
                        $target = $tokens[3];
    
                        $onlyOperand = $tokens[1];
                        
                        $expr = @("NOT", $onlyOperand);
    
                        if ($heap.storage[$target].hasSignal -eq $true) {
                            continue;
                        }
    
                        PerformOperationWithValue -expr $expr `
                            -target $target `
                            -ops $ops `
                            -heap $heap `
                            -index $i `
                            -instructionList $instructionList `
                            -isBinary;
    
                    }
                    else {
                        $valueOperand = $tokens | Where-Object { $_ -match "\d" };
        
                        $wireOperand = @($tokens[0], $tokens[2]) | Where-Object { $_ -cmatch "^[a-z]*$" };
        
                        [string]$target = $tokens[4];
    
                        # perform op to apply signal to the target wire
                        [System.Array]$splitInstr = $instr.instruction.Split(" -> ", [System.StringSplitOptions]::RemoveEmptyEntries);
    
                        [System.Array]$expr = @($splitInstr[0], $splitInstr[1], $splitInstr[2]);
    
                        if ($heap.storage[$target].hasSignal -eq $true -or $heap.storage[$wireOperand].hasSignal -eq $false) {
                            continue;
                        }
    
                        PerformOperationWithValue -expr $expr `
                            -target $target `
                            -ops $ops `
                            -heap $heap `
                            -index $i `
                            -instructionList $instructionList;
                    }
                    
                }
                #condition for when the line is just a value applying a signal to a wire
                elseif ($isprovidingvalue -eq $true) {
    
                    $valueOperand = $tokens | Where-Object { $_ -match "\d" };
                    
                    $wireOperand = @($tokens[0], $tokens[2]) | Where-Object { $_ -cmatch "^[a-z]*$" };
                    
                    # this instruction is skipped if it was completed already more than likely the signal is on the wire already
                    # so just apply signal to the wire
                    $heap.storage[$wireOperand].value = [uint16]($valueOperand);
                    $heap.storage[$wireOperand].hasSignal = $true;
                    $instructionList[$i].wasCompleted = $true;
                    # Write-Host "ONLY PROVIDING VALUE LIKE THIS x -> y: $($instr.instruction)"
                    # Write-Host "3 was COMPLETED holy fucking SHIT!!!! for this instruction $($instr.instruction) - was completed $($instr.wasCompleted)"
    
                }
                # condition for when the line is a wire applying a signal to another wire
                elseif ($isconnectingtwowires -eq $true) {
                    if ($heap.storage[$tokens[0]].hasSignal -eq $true) {
                        # Write-Host "WHATS THE GODDAMN INSTRUCTION HERE: $($instr.instruction)" -ForegroundColor Cyan;
                        # Write-Host "connecting these two goddamn wires $($tokens[0]) -> $($tokens[2])" -ForegroundColor Yellow;
                        $heap.storage[$tokens[2]].value = $heap.storage[$tokens[0]].value;
                        $heap.storage[$tokens[2]].hasSignal = $true;
    
                        $instructionList[$i].wasCompleted = $true;
                        # Write-Host "4 was COMPLETED holy fucking SHIT!!!! for this instruction $($instr.instruction) - was completed $($instr.wasCompleted)"
                    }
                    else {
                        continue;
                    }
                }
    
            }
        } while ($heap.storage["a"].hasSignal -eq $false);
    
        $answer1 = $heap.storage["a"].value;
    
        Write-Host "[INFO]: solving part one..." -ForegroundColor Cyan
        Write-Host "[INFO]: part one answer is $answer1" -ForegroundColor Green

    }
    else {

        # reset instruction set and skip the instruction that includes b because we're using the value that b got from a after part 1
        [System.Collections.ArrayList]$instructionList = [System.Collections.ArrayList]@();
    
        $myInput = Read-Input "input2" $PSScriptRoot
        $lines = Get-InputLines $myInput
        
        foreach ($l in $lines) {
            [string]$line = $l;
            
            # if ($line -cmatch "^-> b$") { continue; }
    
            $instructionList.Add([Instruction]::new($line)) | Out-Null;
    
            $hasop = $(HasOperatorInLine($line));
            $isconnecting = $(IsConnectingTwoWires($line));
            $isprovidingvalue = $(IsProvidingValueToWire($line));
            $exprHasValue = $(ExprHasValue($line));
            if ($hasop -eq $true -and $exprHasValue -eq $false) {
                $operationsLines.Add($line) | Out-Null;
            }
            elseif ($isconnecting -eq $true) {
                $connectingTwoWiresList.Add($line) | Out-Null;
            }
            elseif ($isprovidingvalue -eq $true) {
                $valueToWireList.Add($line) | Out-Null;
            }
            elseif ($exprHasValue -eq $true) {
                $exprsWithValue.Add($line)[1] | Out-Null;
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
                        $heap.storage[$token] = [Wire]::new($token, 0)
                    }
                }
            }
        }
    
        #part 2
        # override b with value a
        $heap.storage["b"].value = [uint16](3176);
        $heap.storage["b"].hasSignal = $true;
    
        # reset all wires including a but don't reset b
    
        foreach ($key in $heap.storage.Keys) {
            if ($key -ne "b") {
                $heap.storage[$key].value = 0;
                $heap.storage[$key].hasSignal = $false;
            }
        }
    
        # assign values to whom are instructed to be assigned values
        foreach ($l in $valueToWireList) {
            [string]$line = $l;
    
            $tokens = $line.Split(" ");
    
            $value = $tokens[0];
            $var = $tokens[2];
    
            $heap.storage[$var].value = [uint16]($value);
            $heap.storage[$var].hasSignal = $true;
    
            for ($i = 0; $i -lt $instructionList.Count; $i++) {
                [Instruction]$instr = $instructionList[$i];
    
                if ($line -match $instr.instruction) {
                    $instructionList[$i].wasCompleted = $true;
                }
            }
        }
    
        # loop through all lines again over and over until a particular wire has signal applied to it
        do {
            for ($i = 0; $i -lt $instructionList.Count; $i++) {
                [Instruction]$instr = $instructionList[$i];
    
                if ($i -eq 0) {
                    # Write-Host "CHECKING BEGINNING AFTER A BREAK!" -ForegroundColor Green
                    # Write-Host "instruction starting with $($instr.instruction)" -ForegroundColor Cyan;
    
                    # Write-Host "print heap here i guess" -ForegroundColor Magenta;
    
                    if ($instructionList.Count -le 262) {
                        # foreach ($key in $heap.storage.Keys) {
                        #     Write-Host "wire $($key): $($heap.storage[$key].value) - $($heap.storage[$key].hasSignal) "; 
                        # }
        
                        # Write-Host "where am i stuck dq: $($heap.storage["dq"].value) dr: $($heap.storage["dr"].value)" -ForegroundColor Red;
                        # Write-Host "where am i stuck dq has signal: $($heap.storage["dq"].hasSignal) dr has signal: $($heap.storage["dr"].hasSignal)" -ForegroundColor Red;
                    }
                }
    
                # Write-Host "CURRENT INSTRUCTION $($instr.instruction) was complete $($instr.wasCompleted)" -ForegroundColor Red;
                
                if ($instr.wasCompleted -eq $true) {
                    $instructionList.Remove($instr);
                    Write-Host "REMOVED SOME SHIT!!! $($instr.instruction) instruction list count now $($instructionList.Count)" -ForegroundColor Magenta;
    
                    # Write-Host "what is aw $($heap.storage["aw"].value)" -ForegroundColor Cyan;
                    # Write-Host "what is ay $($heap.storage["ay"].value)" -ForegroundColor Cyan;
                    # Write-Host "what is az $($heap.storage["az"].value)" -ForegroundColor Cyan;
    
                    # Write-Host "what the fuck is lx $($heap.storage["lx"].value)" -ForegroundColor Yellow;
    
                    break;
                }
    
                $tokens = $instr.instruction.Split(" ");
    
                $hasop = $(HasOperatorInLine($instr.instruction));
                $exprHasValue = $(ExprHasValue($instr.instruction));
                $isconnectingtwowires = $(IsConnectingTwoWires($instr.instruction));
                $isprovidingvalue = $(IsProvidingValueToWire($instr.instruction));
    
                if ($hasop -eq $true -and $exprHasValue -eq $false) {
    
    
                    $op = $tokens | Where-Object { $_ -cmatch "AND|NOT|LSHIFT|OR|RSHIFT" };
    
                    if ($op -cmatch "NOT") {
                        $onlyOperand = $tokens[1];
    
                        $target = $tokens[3];
    
                        $expr = @("NOT", $onlyOperand);
    
                        if ($heap.storage[$onlyOperand].hasSignal -eq $false) {
                            continue;
                        }
    
                        PerformOperation -expr $expr `
                            -target $target `
                            -ops $ops `
                            -heap $heap `
                            -index $i `
                            -instructionList $instructionList `
                            -isBinary;
                    }
                    else {
                        $lhoperand = $tokens[0];
        
                        $rhoperand = $tokens[2];
        
                        [Wire]$wireLeft = $heap.storage[$lhoperand];
                        [Wire]$wireRight = $heap.storage[$rhoperand];
        
                        [string]$target = $tokens[4];
        
                        if ($heap.storage[$target].hasSignal -eq $true) {
                            continue;
                        }
        
                        if ($wireLeft.hasSignal -eq $true -and `
                                $wireRight.hasSignal -eq $true -and `
                                $heap.storage[$target].hasSignal -eq $false
                        ) {
                            # Write-Host " 5 ONLY EXPR WITH VALUE like this $($instructionList[$i].instruction)"
        
                            # perform op to apply signal to the target wire
                            [System.Array]$splitInstr = $instr.instruction.Split(" -> ", [System.StringSplitOptions]::RemoveEmptyEntries);
        
                            [System.Array]$expr = @($splitInstr[0], $splitInstr[1], $splitInstr[2]);
        
                            PerformOperation -expr $expr `
                                -target $target `
                                -ops $ops `
                                -heap $heap `
                                -index $i `
                                -instructionList $instructionList;
                            
                        }
                        else {
                            continue;
                        }
                    }
    
                }
    
                #condition to perform operation on an instruction set that has a wire and a value in the left and/or right operands in the expression
                elseif ($exprHasValue -eq $true) {
    
                    $op = $tokens | Where-Object { $_ -cmatch "AND|OR|NOT|LSHIFT|RSHIFT" };
    
                    if ($op -cmatch "NOT") {
                        $target = $tokens[3];
    
                        $onlyOperand = $tokens[1];
                        
                        $expr = @("NOT", $onlyOperand);
    
                        if ($heap.storage[$target].hasSignal -eq $true) {
                            continue;
                        }
    
                        PerformOperationWithValue -expr $expr `
                            -target $target `
                            -ops $ops `
                            -heap $heap `
                            -index $i `
                            -instructionList $instructionList `
                            -isBinary;
    
                    }
                    else {
                        $valueOperand = $tokens | Where-Object { $_ -match "\d" };
        
                        $wireOperand = @($tokens[0], $tokens[2]) | Where-Object { $_ -cmatch "^[a-z]*$" };
        
                        [string]$target = $tokens[4];
    
                        # perform op to apply signal to the target wire
                        [System.Array]$splitInstr = $instr.instruction.Split(" -> ", [System.StringSplitOptions]::RemoveEmptyEntries);
    
                        [System.Array]$expr = @($splitInstr[0], $splitInstr[1], $splitInstr[2]);
    
                        if ($heap.storage[$target].hasSignal -eq $true -or $heap.storage[$wireOperand].hasSignal -eq $false) {
                            continue;
                        }
    
                        PerformOperationWithValue -expr $expr `
                            -target $target `
                            -ops $ops `
                            -heap $heap `
                            -index $i `
                            -instructionList $instructionList;
                    }
                    
                }
                #condition for when the line is just a value applying a signal to a wire
                elseif ($isprovidingvalue -eq $true) {
    
                    $valueOperand = $tokens | Where-Object { $_ -match "\d" };
                    
                    $wireOperand = @($tokens[0], $tokens[2]) | Where-Object { $_ -cmatch "^[a-z]*$" };
                    
                    # this instruction is skipped if it was completed already more than likely the signal is on the wire already
                    # so just apply signal to the wire
                    $heap.storage[$wireOperand].value = [uint16]($valueOperand);
                    $heap.storage[$wireOperand].hasSignal = $true;
                    $instructionList[$i].wasCompleted = $true;
                    # Write-Host "ONLY PROVIDING VALUE LIKE THIS x -> y: $($instr.instruction)"
                    # Write-Host "3 was COMPLETED holy fucking SHIT!!!! for this instruction $($instr.instruction) - was completed $($instr.wasCompleted)"
    
                }
                # condition for when the line is a wire applying a signal to another wire
                elseif ($isconnectingtwowires -eq $true) {
                    if ($heap.storage[$tokens[0]].hasSignal -eq $true) {
                        # Write-Host "WHATS THE GODDAMN INSTRUCTION HERE: $($instr.instruction)" -ForegroundColor Cyan;
                        # Write-Host "connecting these two goddamn wires $($tokens[0]) -> $($tokens[2])" -ForegroundColor Yellow;
                        $heap.storage[$tokens[2]].value = $heap.storage[$tokens[0]].value;
                        $heap.storage[$tokens[2]].hasSignal = $true;
    
                        $instructionList[$i].wasCompleted = $true;
                        # Write-Host "4 was COMPLETED holy fucking SHIT!!!! for this instruction $($instr.instruction) - was completed $($instr.wasCompleted)"
                    }
                    else {
                        continue;
                    }
                }
    
            }
        } while ($heap.storage["a"].hasSignal -eq $false);
    
        $answer2 = $heap.storage["a"].value;
    
        
    
        Write-Host "[INFO]: solving part two..." -ForegroundColor Cyan
        Write-Host "[INFO]: part two answer is $answer2" -ForegroundColor Green
    }

}

PartOneAndTwo
