#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.12.sh
    lz4-1.9.3.sh
    timezone2022a.sh
    pcre2-10.40.sh
    openssl-1.1.1p.sh
    c-ares-1.18.1.sh
    cacert-2022-04-26.sh
    nghttp2-1.47.0.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    dropbear-2022.82.sh
    metalog-20220214.sh
    dnsmasq-2.86.sh
    libssh2-1.10.0.sh
    ncurses-6.3.sh
    mcip-tool-v2.sh
"

PACKAGES_3="
    curl-7.83.1.sh
    nano-6.3.sh
    node-v16.14.2-linux-armv7l.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
