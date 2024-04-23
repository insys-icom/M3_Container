#!/bin/bash

DESCRIPTION="Container offers classic LAMP stack"
CONTAINER_NAME="container_LAMP"
ROOTFS_LIST="rootfs_list_LAMP.txt"

PACKAGES_1="
    Linux-PAM-1.6.1.sh
    zlib-1.3.sh
    tzdb-2024a.sh
    pcre2-10.43.sh
    openssl-3.2.1.sh
    apr-1.7.0.sh
    libuuid-1.0.3.sh
    nghttp2-1.59.0.sh
    jansson-2.14.sh
    cacert-2024-03-11.sh
    mcip.sh
    expat-2.6.0.sh
    libxml2-v2.9.14.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    mcip-tool-v4.sh
    dropbear-2024.84.sh
    metalog-20230719.sh
    apr-util-1.6.1.sh
    sqlite-src-3450100.sh
    ncurses-6.4.sh
"

PACKAGES_3="
    nano-7.2.sh
    httpd-2.4.57.sh
"

PACKAGES_4="
    php-8.3.3.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
