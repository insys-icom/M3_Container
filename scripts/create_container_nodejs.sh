#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.13.sh
    lz4-1.9.4.sh
    timezone2022e.sh
    pcre2-10.40.sh
    openssl-1.1.1q.sh
    c-ares-1.18.1.sh
    cacert-2022-10-11.sh
    nghttp2-1.49.0.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    dropbear-2022.82.sh
    metalog-20220214.sh
    dnsmasq-2.87.sh
    libssh2-1.10.0.sh
    ncurses-6.3.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    curl-7.85.0.sh
    nano-6.4.sh
    node-v16.17.0-linux-armv7l.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
