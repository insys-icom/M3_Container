#!/bin/bash

DESCRIPTION="Container offers classic LAMP stack"
CONTAINER_NAME="container_LAMP"
ROOTFS_LIST="rootfs_list_LAMP.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.13.sh
    timezone2022f.sh
    pcre2-10.40.sh
    openssl-1.1.1s.sh
    apr-1.7.0.sh
    libuuid-1.0.3.sh
    nghttp2-1.51.0.sh
    jansson-2.14.sh
    cacert-2022-10-11.sh
    mcip.sh
    expat-2.5.0.sh
    libxml2-v2.9.14.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    mcip-tool-v4.sh
    dropbear-2022.83.sh
    metalog-20220214.sh
    apr-util-1.6.1.sh
    sqlite-src-3400000.sh
    ncurses-6.3.sh
"

PACKAGES_3="
    nano-7.0.sh
    httpd-2.4.54.sh
"

PACKAGES_4="
    php-8.1.12.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
