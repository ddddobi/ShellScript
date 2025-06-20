#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 {on|off}"
    exit 1
fi
SW=$1

source /root/shell/function.sh

Firewalld_On() {
    SvcStart firewalld
}

Firewalld_Off() {
    SvcStop firewalld
}

case $SW in
    on)  Firewalld_On  ;;
    off) Firewalld_Off ;;
    *)   echo "Usage: $0 {on|off}" ; exit 1 ;;
esac