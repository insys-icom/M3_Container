#!/bin/sh
. /etc/profile

# determine if a listening port for mintest is up
netstat -l | grep 30000
exit $?
