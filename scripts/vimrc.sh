#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 {on|off}"
    exit 1
fi
SW=$1

source /root/shell/function.sh

VimRC(){
    cp -p $SCRIPTDIR/vimrc.txt ~/.vimrc
    if grep -qw nu ~/.vimrc ; then
        echo "[  OK  ] ~/.vimrc 파일 생성"
    else
        echo "[  FAIL  ] ~/.vimrc 파일 생성 실패"
    fi 
}

case $SW in
    on) VimRC ;;
esac
