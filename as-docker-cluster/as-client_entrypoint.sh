#!/usr/bin/env bash
 
/bin/bash
 
passwd -d root
/usr/sbin/sshd -D &

IP=`/sbin/ifconfig | grep "inet" | grep "broadcast" | awk -F " " '{print $2}' | awk '{print $1}'`
echo "Node IP: $IP"

#/usr/bin/python3 -m debugpy --listen 0.0.0.0:$DEBUGPY_PORT /usr/bin/odoo --db_user=odoo --db_host=db --db_password=odoo &

/code/src/aerospike/enterprise/aerospike-admin/build/bin/asadm -e asadmn-setup -Uadmin -Padmin -h node1.asserver.com

wait
