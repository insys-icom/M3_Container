#!/bin/bash

DESCRIPTION="Container similar to the one, the router can create"
CONTAINER_NAME="container_default"
ROOTFS_LIST="rootfs_list_default.txt"

PACKAGES_1=(
    "libxcrypt-4.4.38.sh"
    "mcip.sh"
    "cacert-2025-09-09.sh"
    "zlib-1.3.sh"
    "tzdb-2025b.sh"
)
PACKAGES_2=(
    "lz4-1.10.0.sh"
    "pcre2-10.46.sh"
    "openssl-3.5.3.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2025.88.sh"
    "metalog-20230719.sh"
    "dnsmasq-2.91.sh"
    "lua-5.4.8.sh"
)
PACKAGES=(
    PACKAGES_1[@]
    PACKAGES_2[@]
    PACKAGES_3[@]
)

CLOSED_PACKAGES_1=(
    "hello_world.sh"
)
CLOSED_PACKAGES=(
    CLOSED_PACKAGES_1[@]
)

# in case $1 is "do_nothing" this script will end here
[ "$1" == "do_nothing" ] && return

. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
