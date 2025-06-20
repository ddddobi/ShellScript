#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 {on|off}"
    exit 1
fi
SW=$1

source /root/shell/function.sh

FtpServer_On(){
    # 패키지 설치
    PkgInstall vsftpd ftp
    # 서비스 설정(root 사용자 접근 가능)
    sed -i 's/^root/#root/' /etc/vsftpd/ftpusers
    sed -i 's/^root/#root/' /etc/vsftpd/user_list
    # 서비스 기동
    SvcStart vsftpd

}

FtpServer_Off(){
    # 서비스 종료
    SvcStop vsftpd
}

case $SW in
    on)  FtpServer_On ;;
    off) FtpServer_Off ;;
    *)   echo "Usage: $0 {on|off}" ; exit 1 ;;
esac