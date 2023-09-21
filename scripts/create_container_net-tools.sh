#!/bin/bash

DESCRIPTION="Container with a view network debugging tools"
CONTAINER_NAME="container_net-tools"
ROOTFS_LIST="rootfs_list_net-tools.txt"

PACKAGES_1="
    Linux-PAM-1.5.3.sh
    zlib-1.2.13.sh
    lz4-1.9.4.sh
    lzo-2.10.sh
    tzdb-2023c.sh
    pcre2-10.42.sh
    openssl-3.1.1.sh
    mcip.sh
    cacert-2023-05-30.sh
    nghttp2-1.55.1.sh
    libpcap-1.10.4.sh
    libcap-ng-0.8.3.sh
    iptables-1.8.9.sh
    c-ares-1.19.1.sh
    cJSON-1.7.16.sh
    wireguard-tools-v1.0.20210914.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    mcip-tool-v4.sh
    dropbear-2022.83.sh
    metalog-20230719.sh
    dnsmasq-2.89.sh
    openvpn-2.6.5.sh
    tcpdump-4.99.4.sh
    iperf-3.12.sh
    stunnel-5.70.sh
    HTTPing-2.9.sh
    libssh2-1.11.0.sh
    socat-2.0.0-b9.sh
    libwebsockets-4.3.2.sh
"

PACKAGES_3="
    curl-8.2.0.sh
    nmap-7.94.sh
    mosquitto-2.0.15.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
