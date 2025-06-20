#!/bin/bash

echo -n 'Enter A : '
read A

echo -n 'Enter Operator : '
read OP

echo -n 'Enter C : '
read B

case $OP in
    '+') echo "$A + $B = $(expr $A + $B)" ;;
    '-') echo "$A - $B = $(expr $A - $B)" ;;
    '*') echo "$A * $B = $(expr $A \* $B)" ;; 
    '/') echo "$A / $B = $(expr $A / $B)" ;; 
    *) echo "[ FAIL ] 잘못된 연산자를 선택했습니다." ; exit 1 ;;
esac