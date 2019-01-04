#!/bin/bash

# port
# weight
# backup
# hostlist

#set -x

if [ $# -lt 1 ]; then
    echo "Usage: `basename $0` -p <port> [-w <weight>] [-b] [-f <hostfile>] | [<hostnames>]"
    exit 1
fi

while getopts ':p:w:bf:' arg
do
    case $arg in
        p)
            port=$OPTARG
            ;;
        w)
            weight=$OPTARG
            ;;
        b)
            backup=" backup"
            ;;
        f)
            hostfile=$OPTARG
            ;;
        ?)
            echo "Unknown argument."
            exit 1
            ;;
    esac
done

if [ "$port" == "" ]; then
    echo "Port must be specified."
    exit 1
fi

if [ "$weight" == "" ]; then
    weight="100"
fi

shift $((OPTIND-1))

if [ "$hostfile" == "" -a $# -lt 1 ]; then
    echo "No host given."
    exit 1
elif [ "$hostfile" == "" ]; then
    hostlist="$*"
else
    hostlist="`cat $hostfile` $*"
fi

for h in $hostlist
do
    if host $h &> /dev/null; then
        ip=`host $h | awk '{print $4}'`
        echo "    server $ip:$port max_fails=2 fail_timeout=30s weight=$weight$backup; #$h"
    else
        echo "ERROR: $h has no IP. Exit."
        exit 1
    fi
done

