#!/usr/bin/env bash
 
/bin/bash
 
passwd -d root
/usr/sbin/sshd -D

IP=`/sbin/ifconfig | grep "inet" | grep "broadcast" | awk -F " " '{print $2}' | awk '{print $1}'`
echo "Node IP: $IP"

exec "$@"
