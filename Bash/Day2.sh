set -e;
#! /usr/bin/bash
echo 'hello world'



declare -a my_array=()
# while read line; do
#     my_array+=( "$line" )
# done < sample.txt

while read line; do
    my_array+=( "$line" )
done < input.txt


# echo "${my_array[0]}"

#calculating the required wrapping paper for each gift a little easier: find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l
sum=0
ribbonsum=0
for str in ${my_array[@]}; do
    # echo " line => $str"

    IFS='x'
    # Read the split words into an array 
    # based on space delimiter
    read -ra dimstr <<< "$str"
    unset IFS

    #     # n = 0 => l
    #     # n = 1 => w
    #     # n = 2 => h

    l=${dimstr[0]}
    w=${dimstr[1]}
    h=${dimstr[2]}

    two_lw_mul=$((2 * l * w))
    lw_area=$((l * w))

    two_wh_mul=$((2 * w * h))
    wh_area=$((w * h))
    
    two_hl_mul=$((2 * h * l))
    hl_area=$((h * l))

    # echo "two lw mul => $two_lw_mul"
    # echo "two wh mul => $two_wh_mul"
    # echo "two hl mul => $two_hl_mul"
    
    # got areas to compare


    arr=($lw_area $wh_area $hl_area)

    # echo "arr 0 => ${arr[0]}"
    # echo "arr 1 => ${arr[1]}"
    # echo "arr 2 => ${arr[2]}"

    # Performing Bubble sort for area array
    for ((i = 0; i<3; i++))
    do
        
        for((j = 0; j<3-i-1; j++))
        do
        
            if [ ${arr[j]} -gt ${arr[$((j+1))]} ]
            then
                # swap
                temp=${arr[j]}
                arr[$j]=${arr[$((j+1))]}  
                arr[$((j+1))]=$temp
            fi
        done
    done

    # echo "Array in sorted order :"
    # echo ${arr[*]}

    dimarr=($l $w $h)
    
    # Performing Bubble sort for perimeter array
    for ((i = 0; i<3; i++))
    do
        
        for((j = 0; j<3-i-1; j++))
        do
        
            if [ ${dimarr[j]} -gt ${dimarr[$((j+1))]} ]
            then
                # swap
                temp=${dimarr[j]}
                dimarr[$j]=${dimarr[$((j+1))]}  
                dimarr[$((j+1))]=$temp
            fi
        done
    done

    # echo "Array2 in sorted order :"
    # echo ${dimarr[*]}

    present_ribbon=$((dimarr[0] + dimarr[0] + dimarr[1] + dimarr[1]))

    # echo "present ribbon => $present_ribbon"

    bow_ribbon=$((dimarr[0] * dimarr[1] * dimarr[2]))
    # echo "bow ribbon => $bow_ribbon"

    # echo "current ribbon => $((present_ribbon + bow_ribbon))"

    current_ribbon=$((present_ribbon + bow_ribbon))

    ribbonsum=$((ribbonsum + current_ribbon))

    # echo "ribbonsum => $ribbonsum"

    # echo "sorted 1 => ${arr[0]}"
    # echo "sorted 2 => ${arr[1]}"
    # echo "sorted 3 => ${arr[2]}"

    smallestside=${arr[0]}

    # echo "smallestside as variable => $smallestside"

    # echo "smallestside => $smallestside"

    combined=$(($two_lw_mul + $two_wh_mul + $two_hl_mul))
    # echo "combined => $combined"

    # ADD MIN SOMHOW WHAT THE FUCK WHY IS THIS SO HARD
    combined=$((combined + smallestside))
    # echo "combined + smallestside => $combined"

    sum=$((sum + combined))
    # echo "sum after new sum => $sum"


done

echo "PART 1 ANSWER => $sum"

echo "PART 2 ANSWER => $ribbonsum"