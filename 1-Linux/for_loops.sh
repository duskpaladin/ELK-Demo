#!/bin/bash

#Variables
nums=$(echo {0...9})
ls_out=$(ls)
execs=$(find /home -type -f -perm 777 2> /dev/null)

#Script contains some examples of For Loops

#Loop that looks for 'Hawaii'
for state in ${states[@]}
do
    if [ $state == 'Hawaii' ];
    then
        echo "Hawaii is da best!"
    else
        echo "I am not a fan of Hawaii."
    fi
done

#Loop that prints 3, 5 or 7
for num in ${nums[@]}
do
    if [ $num = 3 ] || [ $num = 5 ] || [ $num = 7 ]
    then
        echo $num
    fi
done

#Loop that prints each item in variable holding output of ls command
for x in ${ls_out[@]}
do
    echo $x
done

#Loop that prints execs on one line per entry
for exec in ${execs[@]}
do
    echo $exec
done