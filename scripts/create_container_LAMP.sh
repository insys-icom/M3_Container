#!/bin/bash

DESCRIPTION="Container offers classic LAMP stack"
CONTAINER_NAME="container_LAMP"
ROOTFS_LIST="rootfs_list_LAMP.txt"

PACKAGES_1=(
    "libxcrypt-4.4.38.sh"
    "mcip.sh"
    "cacert-2025-09-09.sh"
    "zlib-1.3.sh"
    "tzdb-2025b.sh"
)
PACKAGES_2=(
    "pcre2-10.46.sh"
    "openssl-3.5.3.sh"
    "apr-1.7.6.sh"
    "libuuid-1.0.3.sh"
    "nghttp2-1.67.1.sh"
    "jansson-2.14.1.sh"
    "expat-2.7.2.sh"
    "libxml2-v2.9.14.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2025.88.sh"
    "metalog-20230719.sh"
    "apr-util-1.6.3.sh"
    "sqlite-src-3500400.sh"
    "ncurses-6.5.sh"
)
PACKAGES_4=(
    "nano-8.6.sh"
    "httpd-2.4.65.sh"
)
PACKAGES_5=(
    "php-8.4.12.sh"
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
