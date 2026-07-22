#!/bin/bash

DESCRIPTION="Container offers classic LAMP stack"
CONTAINER_NAME="container_LAMP"
ROOTFS_LIST="rootfs_list_LAMP.txt"

PACKAGES_1=(
    "libxcrypt-4.5.2.sh"
    "mcip.sh"
    "cacert-2026-07-16.sh"
    "zlib-1.3.2.sh"
    "tzdb-2026c.sh"
)
PACKAGES_2=(
    "pcre2-10.47.sh"
    "openssl-3.6.3.sh"
    "apr-1.7.6.sh"
    "libuuid-1.0.3.sh"
    "nghttp2-1.69.0.sh"
    "jansson-2.15.1.sh"
    "expat-2.8.2.sh"
    "libxml2-v2.9.14.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.38.0.sh"
    "dropbear-2026.92.sh"
    "metalog-20260221.sh"
    "apr-util-1.6.3.sh"
    "sqlite-src-3530300.sh"
    "ncurses-6.6.sh"
)
PACKAGES_4=(
    "nano-9.1.sh"
    "httpd-2.4.68.sh"
)
PACKAGES_5=(
    "php-8.5.8.sh"
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
