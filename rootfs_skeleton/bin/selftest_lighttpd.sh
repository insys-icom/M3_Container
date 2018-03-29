#!/bin/sh
. /etc/profile

# retrive http index site
cd /tmp
rm -Rf index.html
wget http://insys:icom@localhost
exit $?
