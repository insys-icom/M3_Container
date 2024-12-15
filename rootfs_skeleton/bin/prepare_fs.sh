#!/bin/bash

# prepare TMPFS directories
/bin/mkdir -p /tmp/lock /tmp/run

# link shared memory directoy to tmp
/bin/ln -s /tmp /dev/shm

# create tun device node for OpenVPN
/bin/mknod /dev/net/tun c 10 200
