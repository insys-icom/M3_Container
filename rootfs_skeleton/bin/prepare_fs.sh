#!/bin/bash

# prepare TMPFS directories
/bin/mkdir -p /tmp/lock /tmp/run

# create tun device node for OpenVPN
/bin/mknod /dev/net/tun c 10 200

# create directories for incoming orders and static files
/bin/mkdir -p /data/orders /data/static
/bin/chown user:users /data/orders /data/static

# set ownership of authorized_keys files
/bin/chown user:users /data/etc/authorized_keys_sepia
/bin/chown root:root /data/etc/authorized_keys_root
