#!/bin/bash

# for test
cmd=sleep
sleep 10 &

for n in {1..5}
do
    ret=`ps aux | grep -v grep \
                | grep ${cmd:-matchnoneprocess} | awk '{print $2}'`    # default matchnoneprocess for security
    if [ -z "$ret" ]; then
        [ $n -eq 1 ] && echo "Nothing to kill." \
                     || echo "Killed successfully."
        break
    elif [ $n -le 3 ]; then
        echo "Killing for the $n time..."
        kill $ret
        sleep 10 &     # for test
    elif [ $n -eq 4 ]; then
        echo "Force killing..."
        kill -9 $ret
        sleep 10 &     # for test
    elif [ $n -eq 5 ]; then
        echo "Force kill failed. Exit."
        exit 1
    fi
    sleep $n
done
