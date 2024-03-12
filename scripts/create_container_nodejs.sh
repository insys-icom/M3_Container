#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1="
    Linux-PAM-1.6.0.sh
    zlib-1.3.sh
    lz4-1.9.4.sh
    tzdb-2024a.sh
    pcre2-10.43.sh
    openssl-3.2.1.sh
    c-ares-1.27.0.sh
    cacert-2024-03-11.sh
    nghttp2-1.59.0.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    dropbear-2022.83.sh
    metalog-20230719.sh
    libssh2-1.11.0.sh
    ncurses-6.4.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    curl-8.6.0.sh
    nano-7.2.sh
    node-v20.10.0-linux-armv7l.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
