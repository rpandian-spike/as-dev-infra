#!/bin/bash
set -e

export ASD_DIR=${ASD_DIR:-/code/src/aerospike/enterprise/asd}
mkdir -p ${ASD_DIR}
export CORES=$(grep -c ^processor /proc/cpuinfo)
export SERVICE_THREADS=${SERVICE_THREADS:-$CORES}
export TRANSACTION_QUEUES=${TRANSACTION_QUEUES:-$CORES}
export TRANSACTION_THREADS_PER_QUEUE=${TRANSACTION_THREADS_PER_QUEUE:-4}
#export LOGFILE=${LOGFILE:-/dev/null}
export SERVICE_ADDRESS=${SERVICE_ADDRESS:-any}
export SERVICE_PORT=${SERVICE_PORT:-3000}
export HB_ADDRESS=${HB_ADDRESS:-any}
export HB_PORT=${HB_PORT:-3001}
export FABRIC_ADDRESS=${FABRIC_ADDRESS:-any}
export FABRIC_PORT=${FABRIC_PORT:-3002}
export NAMESPACE=${NAMESPACE:-ssd-store}
export REPL_FACTOR=${REPL_FACTOR:-1}
export MEM_GB=${MEM_GB:-1}
export DEFAULT_TTL=${DEFAULT_TTL:-30d}
export STORAGE_GB=${STORAGE_GB:-5}
export FEATURE_KEY_FILE=${FEATURE_KEY_FILE:-${ASD_DIR}/features.conf}
export NSUP_PERIOD=${NSUP_PERIOD:-1h}

export AS_CLUSTER_NAME=${AS_CLUSTER_NAME:-rp_as-cluster}
export TLS_CLUSTER_NAME=${TLS_CLUSTER_NAME:-bob-cluster-a}
export AS_CLUSTER_NODE_DIR=${AS_CLUSTER_NODE_DIR:-${ASD_DIR}/node_$SERVICE_PORT}
rm -rf ${AS_CLUSTER_NODE_DIR}
mkdir -p ${AS_CLUSTER_NODE_DIR}
export WORK_DIR=${WORK_DIR:-${AS_CLUSTER_NODE_DIR}/cache}
mkdir -p ${WORK_DIR}/smd
export LOGFILE=${LOGFILE:-${AS_CLUSTER_NODE_DIR}/asd.log}
export LUA_DIR=${LUA_DIR:-${AS_CLUSTER_NODE_DIR}/lua}
mkdir -p ${LUA_DIR}
export DATA_DIR=${DATA_DIR:-${AS_CLUSTER_NODE_DIR}/${NAMESPACE}.dat}
export INFO_ADDRESS=${INFO_ADDRESS:-any}
export INFO_PORT=${INFO_PORT:-3003}

mkdir -p /var/run/aerospike/

# Fill out conf file with above values
if [ -f ./aerospike.template.conf ]; then
        envsubst < ./aerospike.template.conf > ${AS_CLUSTER_NODE_DIR}/aerospike.conf
        envsubst < ./aerospike.template.conf > /etc/aerospike/aerospike.conf
fi

# if command starts with an option, prepend asd
if [ "${1:0:1}" = '-' ]; then
	set -- asd "$@"
fi

# if asd is specified for the command, start it with any given options
if [ "$1" = '/code/src/aerospike/enterprise/aerospike-server/target/Linux-x86_64/bin/asd' ]; then

	NETLINK=${NETLINK:-eth0}


	# we will wait a bit for the network link to be up.
	NETLINK_UP=0
	NETLINK_COUNT=0
	echo "link $NETLINK state $(cat /sys/class/net/${NETLINK}/operstate)"
	while [ $NETLINK_UP -eq 0 ] && [ $NETLINK_COUNT -lt 20 ]; do
		if grep -q "up" /sys/class/net/${NETLINK}/operstate; then
	                NETLINK_UP=1
	        else
	                sleep 0.1
                	let NETLINK_COUNT=NETLINK_COUNT+1
        	fi
	done
	#IFC=`/sbin/ifconfig | grep "inet"`
	#echo "IFC: $IFC"
	IP=`/sbin/ifconfig | grep "inet" | grep "broadcast" | awk -F " " '{print $2}' | awk '{print $1}'`
	echo "Node IP: $IP:$SERVICE_PORT"
	echo "link $NETLINK state $(cat /sys/class/net/${NETLINK}/operstate) in ${NETLINK_COUNT}"
	echo "launching "$@" --foreground"
	echo "with service-port: $SERVICE_PORT, hb_port: ${HB_PORT} fabric_port: ${FABRIC_PORT} and info_port: ${INFO_PORT}"
	# asd should always run in the foreground
	#service ssh start &
	passwd -d root &
	/usr/sbin/sshd -D &
	#valgrind --tool=callgrind -v --dump-every-bb=1000000000 --callgrind-out-file=${AS_CLUSTER_NODE_DIR}/asd-callgrind.out "$@" &
	"$@" &
	wait
	#set -- "$@" --foreground
fi

# the command isn't asd so run the command the user specified

exec "$@"
