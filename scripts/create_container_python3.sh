#!/bin/bash

DESCRIPTION="Container running Python 3"
CONTAINER_NAME="container_python3"
ROOTFS_LIST="rootfs_list_python3.txt"

PACKAGES_1=(
    "libxcrypt-4.5.2.sh"
    "mcip.sh"
    "cacert-2025-12-02.sh"
    "zlib-1.3.sh"
    "tzdb-2025c.sh"
)
PACKAGES_2=(
    "lz4-1.10.0.sh"
    "bzip2-1.0.8.sh"
    "pcre2-10.47.sh"
    "openssl-3.6.0.sh"
    "libuuid-1.0.3.sh"
    "libffi-3.5.0.sh"
    "xz-5.8.2.sh"
    "certifi.sh"
    "charset-normalizer-3.4.4.sh"
    "idna-3.11.sh"
    "requests-2.32.5.sh"
    "urllib3-2.6.2.sh"
    "paho.mqtt.eclipse-1.6.1.sh"
    "pyserial-3.5.sh"
    "pymodbus-3.11.4.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2025.89.sh"
    "sqlite-src-3510100.sh"
    "metalog-20230719.sh"
    "ncurses-6.5.sh"
)
PACKAGES_4=(
    "nano-8.7.sh"
    "python-3.14.2.sh"
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
