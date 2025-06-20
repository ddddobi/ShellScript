#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 {on|off}"
    exit 1
fi
SW=$1

source /root/shell/function.sh

HttpdServer_On(){
    # 패키지 설치
    PkgInstall httpd mod_ssl
    # 서비스 설정
    echo WEB > /var/www/html/index.html
    # 서비스 기동
    SvcStart httpd
}

HttpdServer_Off(){
    SvcStop httpd
}

case $SW in
    on)  HttpdServer_On ;;
    off) HttpdServer_Off ;;
    *)   echo "Usage: $0 {on|off}" ; exit 1 ;;
esac
