#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: `basename $0` <hostfile> <scriptfile>"
    exit 1
fi

hostfile=$1
scriptfile=$2

for h in `cat $hostfile`
do
    scp -q -o StrictHostKeyChecking=no $scriptfile $h:/tmp
    ssh -q -o StrictHostKeyChecking=no $h /bin/bash /tmp/$scriptfile
done
