#!/bin/bash

#HOSTS=/etc/hosts
HOSTS=/root/shell/hosts
NET=192.168.10

for i in $(seq 200 230)
do
    echo "$NET.$i  linux$i.example.com linux$i" >> $HOSTS
done

cat $HOSTS