#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1=(
    "libxcrypt-4.4.36.sh"
    "mcip.sh"
    "cacert-2024-11-26.sh"
    "zlib-1.3.sh"
    "tzdb-2024b.sh"
)
PACKAGES_2=(
    "lz4-1.10.0.sh"
    "pcre2-10.44.sh"
    "openssl-3.4.0.sh"
    "c-ares-1.33.1.sh"
    "nghttp2-1.64.0.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2024.86.sh"
    "metalog-20230719.sh"
    "libssh2-1.11.1.sh"
    "ncurses-6.5.sh"
)
PACKAGES_4=(
    "curl-8.11.0.sh"
    "nano-8.2.sh"
    "node-v20.17.0-linux-armv7l.sh"
)

PACKAGES=(
    PACKAGES_1[@]
    PACKAGES_2[@]
    PACKAGES_3[@]
    PACKAGES_4[@]
)

# in case $1 is "do_nothing" this script will end here
[ "$1" == "do_nothing" ] && return

. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
