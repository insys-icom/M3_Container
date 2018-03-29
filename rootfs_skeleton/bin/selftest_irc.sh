#!/bin/sh
. /etc/profile

# determine if a listening port for IRC (6667) is up
netstat -l | grep 6667
exit $?
