#!/bin/bash

BASEDIR=/root/shell
SERVERLIST=$BASEDIR/server.list

# 서버 목록 파일 생성
: <<EOT
cat << EOF > $SERVERLIST
192.168.10.10
192.168.10.20
192.168.10.30
EOT

for IP in $(cat $SERVERLIST)
do
    ftp -n $IP 21 << EOF
    user root soldesk1.
    lcd /test
    cd /tmp
    bin
    hash
    prompt
    mput testfile.txt
    quit
EOF
done