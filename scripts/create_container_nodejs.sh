#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1=(
    "libxcrypt-4.5.2.sh"
    "mcip.sh"
    "cacert-2026-03-19.sh"
    "zlib-1.3.sh"
    "tzdb-2026a.sh"
)
PACKAGES_2=(
    "lz4-1.10.0.sh"
    "pcre2-10.47.sh"
    "openssl-3.6.2.sh"
    "c-ares-1.34.6.sh"
    "nghttp2-1.69.0.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2025.89.sh"
    "metalog-20260221.sh"
    "libssh2-1.11.1.sh"
    "ncurses-6.5.sh"
)
PACKAGES_4=(
    "curl-8.19.0.sh"
    "nano-9.0.sh"
    "node-v22.21.1-linux.sh"
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
