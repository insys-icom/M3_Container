#!/bin/sh
. /etc/profile

# retrive http index site
cd /tmp
rm -Rf index.html
wget http://insys:icom@localhost
[ $? != 0 ] && exit 1

# look for "PHP" within index site
cat index.html | grep "PHP"
exit $?