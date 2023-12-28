#!/bin/bash

DESCRIPTION="Container with a view network debugging tools"
CONTAINER_NAME="container_net-tools"
ROOTFS_LIST="rootfs_list_net-tools.txt"

PACKAGES_1="
    Linux-PAM-1.5.3.sh
    zlib-1.3.sh
    lz4-1.9.4.sh
    lzo-2.10.sh
    tzdb-2023d.sh
    pcre2-10.42.sh
    openssl-3.2.0.sh
    mcip.sh
    cacert-2023-12-12.sh
    nghttp2-1.58.0.sh
    libpcap-1.10.4.sh
    libcap-ng-0.8.4.sh
    iptables-1.8.10.sh
    c-ares-1.24.0.sh
    cJSON-1.7.17.sh
    wireguard-tools-v1.0.20210914.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    mcip-tool-v4.sh
    dropbear-2022.83.sh
    metalog-20230719.sh
    dnsmasq-2.89.sh
    openvpn-2.6.8.sh
    tcpdump-4.99.4.sh
    iperf-3.12.sh
    stunnel-5.71.sh
    HTTPing-2.9.sh
    libssh2-1.11.0.sh
    socat-2.0.0-b9.sh
    libwebsockets-4.3.3.sh
"

PACKAGES_3="
    curl-8.5.0.sh
    nmap-7.94.sh
    mosquitto-2.0.18.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
