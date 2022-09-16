#!/bin/bash

DESCRIPTION="Container similar to the one, the router can create"
CONTAINER_NAME="container_default"
ROOTFS_LIST="rootfs_list_default.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.12.sh
    lz4-1.9.4.sh
    timezone2022c.sh
    pcre2-10.40.sh
    openssl-1.1.1q.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    mcip-tool-v4.sh
    dropbear-2022.82.sh
    metalog-20220214.sh
    dnsmasq-2.86.sh
"

PACKAGES_3="
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
