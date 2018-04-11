#!/bin/bash
PID=$(docker inspect --format '{{.State.Pid}}' $1)
nsenter -t $PID -u -i -n -p
