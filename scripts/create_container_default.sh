#!/bin/bash

DESCRIPTION="Container similar to the one, the router can create"
CONTAINER_NAME="container_default"
ROOTFS_LIST="rootfs_list_default.txt"

PACKAGES_1="
    Linux-PAM-1.5.3.sh
    zlib-1.2.13.sh
    lz4-1.9.4.sh
    tzdb-2023c.sh
    pcre2-10.42.sh
    openssl-3.1.0.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    mcip-tool-v4.sh
    dropbear-2022.83.sh
    metalog-20220214.sh
    dnsmasq-2.89.sh
"

PACKAGES_3="
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
