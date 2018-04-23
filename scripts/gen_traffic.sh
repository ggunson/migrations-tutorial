#!/bin/bash
# starts the query threads in operations.sh

KILL_FILE="/tmp/kill.txt"

touch $KILL_FILE
sleep 20
rm -f $KILL_FILE

echo "Starting selects"
./operations.sh select >> activity.log 2>&1 &
sleep 0.1
echo "Starting inserts"
./operations.sh insert >> activity.log 2>&1 &
sleep 0.3
echo "Starting inserts"
./operations.sh insert >> activity.log 2>&1 &
sleep 0.5
echo "Starting inserts"
./operations.sh insert >> activity.log 2>&1 &
sleep 0.5
echo "Starting inserts"
./operations.sh insert >> activity.log 2>&1 &
sleep 0.5
echo "Starting inserts"
./operations.sh insert >> activity.log 2>&1 &
sleep 0.5
echo "Starting updates"
./operations.sh update >> activity.log 2>&1 &
sleep 0.5
echo "Starting updates"
./operations.sh update >> activity.log 2>&1 &
sleep 0.5
echo "Starting deletes"
./operations.sh delete >> activity.log 2>&1 &

exit 0
