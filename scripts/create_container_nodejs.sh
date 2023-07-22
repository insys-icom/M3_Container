#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1="
    Linux-PAM-1.5.3.sh
    zlib-1.2.13.sh
    lz4-1.9.4.sh
    tzdb-2023c.sh
    pcre2-10.42.sh
    openssl-3.1.1.sh
    c-ares-1.19.1.sh
    cacert-2023-05-30.sh
    nghttp2-1.55.1.sh
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
    curl-8.2.0.sh
    nano-7.2.sh
    node-v20.5.0-linux-armv7l.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
