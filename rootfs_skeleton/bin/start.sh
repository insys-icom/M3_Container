#!/bin/sh

# set a default gateway:
/bin/ip route add default via 192.168.1.1

# start a telnet server without authentication
#/bin/telnetd -l /bin/sh

