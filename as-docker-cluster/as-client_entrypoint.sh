#!/usr/bin/env bash
 
/bin/bash
 
passwd -d root
/usr/sbin/sshd -D &

IP=`/sbin/ifconfig | grep "inet" | grep "broadcast" | awk -F " " '{print $2}' | awk '{print $1}'`
echo "Node IP: $IP"

#python3 -m debugpy --listen 0.0.0.0:$DEBUGPY_PORT --wait-for-client ./examples/client/get_async.py 

#cd /code/src/aerospike/enterprise/scan_partition-python
#python3 /code/src/aerospike/enterprise/scan_partition-python/rp-setup.py build --force
#python3 /code/src/aerospike/enterprise/scan_partition-python/rp-setup.py install --force

sleep 2

/code/src/aerospike/enterprise/aerospike-admin/build/bin/asadm -e asadmn-setup -Uadmin -Padmin -h as-s1.as-network.com

wait
