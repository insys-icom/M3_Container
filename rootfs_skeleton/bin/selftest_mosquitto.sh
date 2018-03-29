#!/bin/sh
. /etc/profile

# determine if a listening port for mosquitto is up
netstat -l | grep 1884
exit $?
