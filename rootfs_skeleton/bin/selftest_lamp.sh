#!/bin/sh
. /etc/profile

wget -O - http://localhost | grep 'Welcome to Apache 2 with PHP support'
exit $?
