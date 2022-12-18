#!/bin/bash

# prepare TMPFS directories
/bin/mkdir -p /tmp/lock /tmp/run

# create tun device node for OpenVPN
/bin/mknod /dev/net/tun c 10 200
