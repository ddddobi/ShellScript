#!/bin/bash

for i in $(seq 1 10)
do
    
    PERCENT=$(expr $i \* 10)
    echo -ne "$PERCENT% |"

    for j in $(seq $i)
    do      
        echo  -ne "=="
    done

    # echo -ne "\n"
    if [ $i -eq 10 ]; then
        echo -ne "| complet"
        echo 
    else
        echo -ne ">"
    fi

    echo -ne "\r"
    sleep 1
done