#!/bin/bash

echo -n "Enter A : "
read A  
echo -n "Enter B : "
read B
#echo "$A : $B"

cat <<EOF
 ==================================================
|      (1). +    (2). -    (3). *    (4). /        | 
 ==================================================
EOF

echo -n "Enter Your Choice ? : "
read OP

case $OP in 
    1) echo "$A + $B = $(expr $A + $B)" ;;
    2) echo "$A - $B = $(expr $A - $B)" ;;
    3) : ;;
    4) : ;;
    *) echo "[ FAIL ] 잘못된 연산자를 선택 했습니다." ; exit 1 ;;
esac



