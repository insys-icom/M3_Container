#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1=(
    "libxcrypt-4.4.38.sh"
    "mcip.sh"
    "cacert-2024-12-31.sh"
    "zlib-1.3.sh"
    "tzdb-2025a.sh"
)
PACKAGES_2=(
    "lz4-1.10.0.sh"
    "pcre2-10.45.sh"
    "openssl-3.4.1.sh"
    "c-ares-1.34.4.sh"
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
    "curl-8.12.1.sh"
    "nano-8.3.sh"
    "node-v22.13.0-linux.sh"
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
