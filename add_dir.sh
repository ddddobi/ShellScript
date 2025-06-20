#!/bin/bash

mkdir -p /test && rm -rf /test/*


for i in $(seq 4)
do
    mkdir -p /test/$i
    for j in $(seq 4)
    do
        mkdir -p /test/"$i"/"$j"
    done    
done

tree /test