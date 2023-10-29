set -e;
#! /usr/bin/bash
echo 'hello world'

function readinput {
    something=$(cat input.txt);
    echo $something;
}

something=$(readinput);

array=("something", 2, "3", 0, 1, true, false)

for i in ${array[@]}; do
    echo "item => $i"
done
