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

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
source ~/.bashrc
nvm install 16.14.0
nvm install 14.19.0
nvm install 12.22.10
nvm install 10.20.0

nvm use 14.19.0
npm install -g node-gyp
npm install -g --force nodemon

/code/src/aerospike/enterprise/aerospike-admin/build/bin/asadm -e asadmn-setup -Uadmin -Padmin -h bob-cluster-a

wait
