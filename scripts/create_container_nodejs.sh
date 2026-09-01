#!/bin/bash

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1=(
    "libxcrypt-4.5.2.sh"
    "mcip.sh"
    "cacert-2026-08-13.sh"
    "zlib-1.3.2.sh"
    "tzdb-2026c.sh"
)
PACKAGES_2=(
    "lz4-1.10.0.sh"
    "pcre2-10.48.sh"
    "openssl-3.6.4.sh"
    "c-ares-1.34.8.sh"
    "nghttp2-1.70.0.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.38.0.sh"
    "dropbear-2026.94.sh"
    "metalog-20260811.sh"
    "libssh2-1.11.1.sh"
    "ncurses-6.6.sh"
)
PACKAGES_4=(
    "curl-8.21.0.sh"
    "nano-9.2.sh"
    "node-v22.23.2-linux.sh"
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
