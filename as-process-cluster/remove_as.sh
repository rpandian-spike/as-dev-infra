#!/usr/bin/bash

service aerospike stop

rm -rf /etc/aerospike
rm -rf /opt/aerospike
rm -rf /var/log/aerospike
rm -rf /var/run/aerospike

rm -rf /etc/init.d/aerospike
rm -rf /etc/logrotate.d/aerospike
rm -rf /usr/bin/aql
rm -rf /usr/bin/asadm
rm -rf /usr/bin/asbackup
rm -rf /usr/bin/asgraphite
rm -rf /usr/bin/asinfo
rm -rf /usr/bin/asloglatency
rm -rf /usr/bin/asrestore
rm -rf /usr/bin/asd
rm -rf /usr/bin/asfixownership
rm -rf /usr/bin/asmigrate2to3

rpm -e aerospike-tools
rpm -e aerospike-server-enterprise
rpm -e aerospike-server-community

userdel aerospike
groupdel aerospike

