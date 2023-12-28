#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1="
    Linux-PAM-1.5.3.sh
    zlib-1.3.sh
    lz4-1.9.4.sh
    tzdb-2023d.sh
    pcre2-10.42.sh
    openssl-3.2.0.sh
    c-ares-1.24.0.sh
    cacert-2023-12-12.sh
    nghttp2-1.58.0.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    dropbear-2022.83.sh
    metalog-20230719.sh
    dnsmasq-2.89.sh
    libssh2-1.11.0.sh
    ncurses-6.4.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    curl-8.5.0.sh
    nano-7.2.sh
    node-v20.10.0-linux-armv7l.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
