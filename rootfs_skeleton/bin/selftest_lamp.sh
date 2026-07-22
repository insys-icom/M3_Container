#!/bin/sh
. /etc/profile

wget --no-check-certificate -O - https://localhost | grep 'Welcome to Apache 2 with PHP support'
exit $?
