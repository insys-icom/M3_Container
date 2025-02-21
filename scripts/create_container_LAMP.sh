#!/bin/bash

DESCRIPTION="Container offers classic LAMP stack"
CONTAINER_NAME="container_LAMP"
ROOTFS_LIST="rootfs_list_LAMP.txt"

PACKAGES_1=(
    "libxcrypt-4.4.38.sh"
    "mcip.sh"
    "cacert-2024-12-31.sh"
    "zlib-1.3.sh"
)
PACKAGES_2=(
    "tzdb-2025a.sh"
    "pcre2-10.45.sh"
    "openssl-3.4.1.sh"
    "apr-1.7.5.sh"
    "libuuid-1.0.3.sh"
    "nghttp2-1.64.0.sh"
    "jansson-2.14.sh"
    "expat-2.6.4.sh"
    "libxml2-v2.9.14.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2024.86.sh"
    "metalog-20230719.sh"
    "apr-util-1.6.3.sh"
    "sqlite-src-3490100.sh"
    "ncurses-6.5.sh"
)
PACKAGES_4=(
    "nano-8.3.sh"
    "httpd-2.4.63.sh"
)
PACKAGES_5=(
    "php-8.4.4.sh"
)

PACKAGES=(
    PACKAGES_1[@]
    PACKAGES_2[@]
    PACKAGES_3[@]
    PACKAGES_4[@]
    PACKAGES_5[@]
)

# in case $1 is "do_nothing" this script will end here
[ "$1" == "do_nothing" ] && return

. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
