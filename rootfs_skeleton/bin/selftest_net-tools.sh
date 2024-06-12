#!/bin/sh
. /etc/profile

iperf --version    || exit $?
curl --version     || exit $?
stunnel -help      || exit $?
openvpn --version  || exit $?
iptables --version || exit $?
tcpdump --version  || exit $?
