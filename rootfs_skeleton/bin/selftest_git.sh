#!/bin/sh
. /etc/profile

# try to init a new git repo
cd /tmp
rm -Rf .git
git init
exit $?
