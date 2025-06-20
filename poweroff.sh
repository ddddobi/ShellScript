#/bin/bash
# poweroff 순서 
# -> server1 -> server2 -> main

for SERVER in server1 server2 main
do
    ssh $SERVER poweroff
    sleep 5;
done
