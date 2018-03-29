#!/bin/sh
. /etc/profile

# determine if a listening port for forte is up
netstat -l | grep 61499
exit $?
