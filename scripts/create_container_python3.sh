#!/bin/bash

DESCRIPTION="Container running Python 3"
CONTAINER_NAME="container_python3"
ROOTFS_LIST="rootfs_list_python3.txt"

PACKAGES_1="
    Linux-PAM-1.5.3.sh
    zlib-1.3.sh
    lz4-1.9.4.sh
    tzdb-2023d.sh
    pcre2-10.42.sh
    openssl-3.2.0.sh
    libuuid-1.0.3.sh
    expat-2.5.0.sh
    libffi-3.4.4.sh
    xz-5.4.5.sh
    cacert-2023-12-12.sh
    certifi.sh
    charset-normalizer-3.3.2.sh
    idna-3.6.sh
    requests-2.31.0.sh
    urllib3-2.1.0.sh
    paho.mqtt.eclipse-1.6.1.sh
    pyserial-3.5.sh
    pymodbus-3.6.2.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    dropbear-2022.83.sh
    sqlite-src-3440200.sh
    metalog-20230719.sh
    ncurses-6.4.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    nano-7.2.sh
    python-3.11.7.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh $1
