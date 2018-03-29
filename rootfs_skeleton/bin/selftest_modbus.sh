#!/bin/sh
. /etc/profile
APP="modbus_to_mqtt_gateway"

# retrive http index site
cd /tmp
rm -Rf index.html
wget http://insys:icom@localhost
[ $? != 0 ] && exit 1

# determine if app gets restarted
PID=$(pgrep "${APP}")
[ $? != 0 ] && exit 1
sleep 2
PID2=$(pgrep "${APP}")
[ $? != 0 ] && exit 1
[ "${PID}" != "${PID2}" ] && exit 1

exit 0
