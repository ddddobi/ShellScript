#/bin/bash

source /root/shell/function.sh

#print_good  "성공 메세지"
#print_info  "정보 메세지"
#print_error "에러 메세지"

IP1=192.168.10.2
IP2=8.8.8.8
IP3=www.google.com

print_info "$IP1"
ping -c 2 -W 1 "$IP1" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    print_good "로컬 네트워크 점검"
else
    print_error "로컬 네트워크 점검 이상 발견"
    cat << EOF
    (ㄱ) VMware >  Edit > Virtual Network Editor
    (ㄴ) VMware > VM > Settings > Network Adapter
    (ㄷ) # ifconfig 
EOF
fi

echo
print_info "ping 8.8.8.8"
ping -c 2 -W 1 "$IP2" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    print_good "외부 네트워크 점검"
else
    print_error "외부 네트워크 점검"
    cat << EOF 
    (ㄱ) # netstat -nr (# route -n, # ip route)
EOF
fi

echo 
print_info "ping www.google.com"
ping -c 2 -W 1 "$IP3" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    print_good "DNS 클라이언트 점검 완료"
else
    print_error "DNS 클라이언트 점검"
    cat << EOF
    (ㄱ) # cat /etc/resolv.conf
EOF
fi