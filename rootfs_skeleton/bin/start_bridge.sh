#!/bin/sh
. /etc/profile

# get IP of eth1 and delete it
IP=$(ip -4 a s dev eth1 | grep inet | cut -d' ' -f6)
ip address delete "${IP}" dev eth1

# create bridge, add eth1 to it and start it with previous IP of eth1
brctl addbr br0
brctl addif br0 eth1
ip link set dev br0 up
ip address add "${IP}" dev br0
