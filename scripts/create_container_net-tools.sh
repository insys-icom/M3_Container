#!/bin/bash

DESCRIPTION="Container with a few network debugging tools"
CONTAINER_NAME="container_net-tools"
ROOTFS_LIST="rootfs_list_net-tools.txt"

PACKAGES_1=(
    "libxcrypt-4.5.2.sh"
    "mcip.sh"
    "cacert-2026-03-19.sh"
    "zlib-1.3.sh"
    "cJSON-1.7.19.sh"
    "tzdb-2026a.sh"
)
PACKAGES_2=(
    "lz4-1.10.0.sh"
    "pcre2-10.47.sh"
    "openssl-3.6.2.sh"
    "nghttp2-1.69.0.sh"
    "libpcap-1.10.6.sh"
    "libcap-ng-0.8.5.sh"
    "iptables-1.8.13.sh"
    "c-ares-1.34.6.sh"
    "wireguard-tools-v1.0.20210914.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2025.89.sh"
    "metalog-20260221.sh"
    "dnsmasq-2.92.sh"
    "openvpn-2.7.1.sh"
    "tcpdump-4.99.6.sh"
    "iperf-3.12.sh"
    "stunnel-5.78.sh"
    "libssh2-1.11.1.sh"
    "socat-1.8.1.1.sh"
    "libwebsockets-4.3.5.sh"
    "bftpd-6.6.sh"
    "rsync-3.4.1.sh"
    "libevent-2.1.12-stable.sh"
    "wpa_supplicant-2.11.sh"
)
PACKAGES_4=(
    "curl-8.19.0.sh"
    "nmap-7.99.sh"
    "mosquitto-2.1.2.sh"
    "addrwatch-1.0.2.sh"
)

PACKAGES=(
    PACKAGES_1[@]
    PACKAGES_2[@]
    PACKAGES_3[@]
    PACKAGES_4[@]
)

# in case $1 is "do_nothing" this script will end here
[ "$1" == "do_nothing" ] && return

. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
