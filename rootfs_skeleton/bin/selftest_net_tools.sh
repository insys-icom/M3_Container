#!/bin/sh
. /etc/profile

# test arping
arping -c 1 localhost || exit 1
