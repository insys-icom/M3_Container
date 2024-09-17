#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1="
    Linux-PAM-1.6.1.sh
    zlib-1.3.sh
    lz4-1.10.0.sh
    tzdb-2024b.sh
    pcre2-10.44.sh
    openssl-3.3.2.sh
    c-ares-1.33.1.sh
    cacert-2024-07-02.sh
    nghttp2-1.63.0.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    dropbear-2024.85.sh
    metalog-20230719.sh
    libssh2-1.11.0.sh
    ncurses-6.5.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    curl-8.10.0.sh
    nano-8.2.sh
    node-v20.17.0-linux-armv7l.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
