#!/usr/bin/env bash
 
/bin/bash
 
passwd -d root
/usr/sbin/sshd -D &

IP=`/sbin/ifconfig | grep "inet" | grep "broadcast" | awk -F " " '{print $2}' | awk '{print $1}'`
echo "Node IP: $IP"

export ASD_HOST=${ASD_HOST:-172.17.0.3}
export AS_INIT=${AS_INIT:-1}

echo "ASD-Host: $ASD_HOST, InitDB: $AS_INIT"
if [ "$AS_INIT" = "1" ]; then
    /code/src/aerospike/enterprise/aerospike-admin/build/bin/asadm -e asadmn-setup -Uadmin -Padmin -h $ASD_HOST
fi

wait
