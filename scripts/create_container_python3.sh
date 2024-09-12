#!/bin/bash

DESCRIPTION="Container running Python 3"
CONTAINER_NAME="container_python3"
ROOTFS_LIST="rootfs_list_python3.txt"

PACKAGES_1="
    Linux-PAM-1.6.1.sh
    zlib-1.3.sh
    lz4-1.10.0.sh
    tzdb-2024a.sh
    pcre2-10.44.sh
    openssl-3.3.1.sh
    libuuid-1.0.3.sh
    libffi-3.4.6.sh
    xz-5.6.2.sh
    cacert-2024-07-02.sh
    certifi.sh
    charset-normalizer-3.3.2.sh
    idna-3.7.sh
    requests-2.32.3.sh
    urllib3-2.2.2.sh
    paho.mqtt.eclipse-1.6.1.sh
    pyserial-3.5.sh
    pymodbus-3.6.9.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.36.1.sh
    dropbear-2024.85.sh
    sqlite-src-3460000.sh
    metalog-20230719.sh
    ncurses-6.5.sh
    mcip-tool-v4.sh
"

PACKAGES_3="
    nano-8.1.sh
    python-3.12.4.sh
"

# in case $1 is "do_nothing" this script will end here; quirk needed for automated daily builds
. $(realpath $(dirname ${BASH_SOURCE[0]}))/create.sh "${@}"
