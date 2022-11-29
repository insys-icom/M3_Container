#!/bin/sh
. /etc/profile

openssl version | grep 'OpenSSL'
exit $?
