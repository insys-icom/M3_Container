#!/bin/bash

DESCRIPTION="Container with a view network debugging tools"
CONTAINER_NAME="container_net-tools"
ROOTFS_LIST="rootfs_list_net-tools.txt"

PACKAGES_1="
    Linux-PAM-1.6.0.sh
    zlib-1.3.sh
    lz4-1.9.4.sh
    lzo-2.10.sh
    tzdb-2024a.sh
    pcre2-10.43.sh
    openssl-3.2.1.sh
    mcip.sh
    cacert-2024-03-11.sh
    nghttp2-1.59.0.sh
    libpcap-1.10.4.sh
    libcap-ng-0.8.4.sh
    iptables-1.8.10.sh
    c-ares-1.27.0.sh
    cJSON-1.7.17.sh
    wireguard-tools-v1.0.20210914.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    mcip-tool-v4.sh
    dropbear-2022.83.sh
    metalog-20230719.sh
    dnsmasq-2.90.sh
    openvpn-2.6.9.sh
    tcpdump-4.99.4.sh
    iperf-3.12.sh
    stunnel-5.72.sh
    HTTPing-2.9.sh
    libssh2-1.11.0.sh
    socat-1.8.0.0.sh
    libwebsockets-4.3.3.sh
"

PACKAGES_3="
    curl-8.6.0.sh
    nmap-7.94.sh
    mosquitto-2.0.18.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
