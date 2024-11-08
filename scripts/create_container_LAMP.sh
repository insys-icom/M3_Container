#!/bin/bash

DESCRIPTION="Container offers classic LAMP stack"
CONTAINER_NAME="container_LAMP"
ROOTFS_LIST="rootfs_list_LAMP.txt"

PACKAGES_1="
    zlib-1.3.sh
    tzdb-2024b.sh
    pcre2-10.44.sh
    openssl-3.3.2.sh
    apr-1.7.5.sh
    libuuid-1.0.3.sh
    nghttp2-1.63.0.sh
    jansson-2.14.sh
    cacert-2024-07-02.sh
    mcip.sh
    expat-2.6.3.sh
    libxml2-v2.9.14.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    mcip-tool-v4.sh
    dropbear-2024.86.sh
    metalog-20230719.sh
    apr-util-1.6.3.sh
    sqlite-src-3460100.sh
    ncurses-6.5.sh
"

PACKAGES_3="
    nano-8.2.sh
    httpd-2.4.62.sh
"

PACKAGES_4="
    php-8.3.11.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
