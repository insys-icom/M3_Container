#!/bin/bash

DESCRIPTION="Container similar to the one, the router can create"
CONTAINER_NAME="container_default"
ROOTFS_LIST="rootfs_list_default.txt"

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
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.38.0.sh"
    "dropbear-2026.94.sh"
    "metalog-20260811.sh"
    "dnsmasq-2.93.sh"
    "lua-5.5.1.sh"
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
