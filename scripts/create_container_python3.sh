#!/bin/bash

DESCRIPTION="Container running Python 3"
CONTAINER_NAME="container_python3"
ROOTFS_LIST="rootfs_list_python3.txt"

PACKAGES_1=(
    "libxcrypt-4.4.36.sh"
    "mcip.sh"
    "cacert-2024-07-02.sh"
)
PACKAGES_2=(
    "zlib-1.3.sh"
    "lz4-1.10.0.sh"
    "bzip2-1.0.8.sh"
    "tzdb-2024b.sh"
    "pcre2-10.44.sh"
    "openssl-3.3.2.sh"
    "libuuid-1.0.3.sh"
    "libffi-3.4.6.sh"
    "xz-5.6.2.sh"
    "certifi.sh"
    "charset-normalizer-3.3.2.sh"
    "idna-3.10.sh"
    "requests-2.32.3.sh"
    "urllib3-2.2.3.sh"
    "paho.mqtt.eclipse-1.6.1.sh"
    "pyserial-3.5.sh"
    "pymodbus-3.7.2.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2024.86.sh"
    "sqlite-src-3460100.sh"
    "metalog-20230719.sh"
    "ncurses-6.5.sh"
)
PACKAGES_4=(
    "nano-8.2.sh"
    "python-3.12.6.sh"
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
