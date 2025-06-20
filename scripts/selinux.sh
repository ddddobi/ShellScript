#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 {on|off}"
    exit 1
fi
SW=$1

source /root/shell/function.sh

# on:
#   permissive -> enforcing
#   disabled -> -> enforcing
# off:
#   enforcing -> permissive
#   disabled  -> disabled

Selinux_On() {
    STATUS=$1
    # echo $STATUS
    case $STATUS in
        Permissive) setenforce 1
                    sed -i 's/^SELINUX=permissive/SELINUX=enforcing/' /etc/selinux/config ;;
        Disabled)   sed -i 's/^SELINUX=disabled/SELINUX=enforcing' /etc/selinux/config
                    echo "[ 주의 ] 반드시 재부팅을 해야 합니다." ;;
    esac
    echo "[  OK  ] $STATUS -> Enforcing 상태로 변경"
}

Selinux_Off() {
    STATUS=$1
    # echo $STATUS
    case $STATUS in
        Enforcing) setenforce 0
                   sed -i 's/^SELINUX=enforcing/SELINUX=permissive' /etc/selinx/config ;;
    esac
    echo "[  OK  ] $STATUS -> Permissive or Disabled 상태로 변경"
}

# SESTATUS = Enforcing|Permissive|Disabled
SESTATUS=$(getenforce)
case $SW in
    on)  Selinux_On  $SESTATUS ;;
    off) Selinux_Off $SESTATUS ;;
    *)   echo "Usage: $0 {on|off}" ; exit 1 ;;
esac
