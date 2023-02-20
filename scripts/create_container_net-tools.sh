#!/bin/bash

DESCRIPTION="Container with a view network debugging tools"
CONTAINER_NAME="container_net-tools"
ROOTFS_LIST="rootfs_list_net-tools.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.13.sh
    lz4-1.9.4.sh
    lzo-2.10.sh
    tzdb-2022g.sh
    pcre2-10.42.sh
    openssl-3.0.8.sh
    mcip.sh
    cacert-2023-01-10.sh
    nghttp2-1.52.0.sh
    libpcap-1.10.3.sh
    libcap-ng-0.8.3.sh
    iptables-1.8.9.sh
    c-ares-1.19.0.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    mcip-tool-v4.sh
    dropbear-2022.83.sh
    metalog-20220214.sh
    dnsmasq-2.89.sh
    openvpn-2.6.0.sh
    tcpdump-4.99.3.sh
    iperf-3.12.sh
    stunnel-5.68.sh
    HTTPing-2.9.sh
    libssh2-1.10.0.sh
    socat-2.0.0-b9.sh
"

PACKAGES_3="
    curl-7.88.1.sh
    nmap-7.93.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
