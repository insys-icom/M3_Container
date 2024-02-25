#!/bin/bash

ARCH="armv7"

DESCRIPTION="Container similar to the one, the router can create"
CONTAINER_NAME="container_default"
ROOTFS_LIST="rootfs_list_default.txt"

PACKAGES_1="
    Linux-PAM-1.6.0.sh
    zlib-1.3.sh
    lz4-1.9.4.sh
    tzdb-2024a.sh
    pcre2-10.43.sh
    openssl-3.2.1.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    mcip-tool-v4.sh
    dropbear-2022.83.sh
    metalog-20230719.sh
    dnsmasq-2.90.sh
"

PACKAGES_3="
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
