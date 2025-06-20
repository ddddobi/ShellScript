#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 {on|off}"
    exit 1
fi
SW=$1

source /root/shell/function.sh

TelnetServer_On() {
    # 패키지 설치
    PkgInstall telnet telnet-server
    # 서비스 기동
    SvcStart telnet.socket
}

TelnetServer_Off() {
    SvcStop telnet.socket
}

case $SW in
    on)  TelnetServer_On  ;;
    off) TelnetServer_Off ;;
    *)   echo "Usage: $0 {on|off}" ; exit 1 ;;
esac
