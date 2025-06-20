#!/bin/bash

BASEDIR=/root/shell
SERVERLIST=$BASEDIR/telnet.list

: <<EOT
cat << EOF > $SERVERLIST
192.168.10.10   root     soldesk1.
192.168.10.20   user01  user01
192.168.10.30   user02  user02
EOF
EOT

cat $SERVERLIST | while read IP UNAME UPASS
do
       Cmd() {
        sleep 2; echo "$UNAME"
        sleep 1; echo "$UPASS"
        sleep 1; echo 'hostname'
        sleep 1; echo 'date'
        sleep 1; echo 'cal'
        sleep 1; echo 'exit'
    }
    Cmd | telnet $IP
done