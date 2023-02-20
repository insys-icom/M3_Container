#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.13.sh
    lz4-1.9.4.sh
    tzdb-2022g.sh
    pcre2-10.42.sh
    openssl-3.0.8.sh
    c-ares-1.19.0.sh
    cacert-2023-01-10.sh
    nghttp2-1.52.0.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    dropbear-2022.83.sh
    metalog-20220214.sh
    dnsmasq-2.89.sh
    libssh2-1.10.0.sh
    ncurses-6.4.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    curl-7.88.1.sh
    nano-7.2.sh
    node-v18.14.1-linux-armv7l.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
