#!/bin/bash

DESCRIPTION="Container running Python 3"
CONTAINER_NAME="container_python3"
ROOTFS_LIST="rootfs_list_python3.txt"

PACKAGES_1="
    Linux-PAM-1.5.3.sh
    zlib-1.2.13.sh
    lz4-1.9.4.sh
    tzdb-2023c.sh
    pcre2-10.42.sh
    openssl-3.1.0.sh
    libuuid-1.0.3.sh
    expat-2.5.0.sh
    libffi-3.4.4.sh
    xz-5.2.6.sh
    cacert-2023-01-10.sh
    python_modules-2022-03-31.sh
    pyserial-3.5.sh
    pymodbus-3.2.2.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    dropbear-2022.83.sh
    sqlite-src-3420000.sh
    metalog-20220214.sh
    ncurses-6.4.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    nano-7.2.sh
    python-3.11.2.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
