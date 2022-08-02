#!/bin/bash

DESCRIPTION="Container running Python 3"
CONTAINER_NAME="container_python3"
ROOTFS_LIST="rootfs_list_python3.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.12.sh
    bzip2-1.0.8.sh
    lz4-1.9.3.sh
    timezone2022a.sh
    pcre2-10.40.sh
    openssl-1.1.1p.sh
    libuuid-1.0.3.sh
    expat-2.4.1.sh
    libffi-3.4.2.sh
    xz-5.2.5.sh
    cacert-2022-04-26.sh
    python_modules-2022-03-31.sh
    pyserial-3.5.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    dropbear-2022.82.sh
    sqlite-src-3390000.sh
    metalog-20220214.sh
    ncurses-6.3.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    nano-6.3.sh
    python-3.10.4.sh
    get-pip-22.0.4.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
