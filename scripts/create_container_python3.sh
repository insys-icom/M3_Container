#!/bin/bash

DESCRIPTION="Container running Python 3"
CONTAINER_NAME="container_python3"
ROOTFS_LIST="rootfs_list_python3.txt"

PACKAGES_1=(
    "libxcrypt-4.5.2.sh"
    "mcip.sh"
    "cacert-2026-03-19.sh"
    "zlib-1.3.sh"
    "tzdb-2026a.sh"
)
PACKAGES_2=(
    "lz4-1.10.0.sh"
    "bzip2-1.0.8.sh"
    "pcre2-10.47.sh"
    "openssl-3.6.2.sh"
    "libuuid-1.0.3.sh"
    "libffi-3.5.0.sh"
    "xz-5.8.3.sh"
    "certifi.sh"
    "charset-normalizer-3.4.7.sh"
    "idna-3.11.sh"
    "requests-2.33.1.sh"
    "urllib3-2.6.3.sh"
    "paho.mqtt.eclipse-1.6.1.sh"
    "pyserial-3.5.sh"
    "pymodbus-3.13.0.sh"
    "mcip-tool-v4.sh"
)
PACKAGES_3=(
    "busybox-1.36.1.sh"
    "dropbear-2025.89.sh"
    "sqlite-src-3530000.sh"
    "metalog-20260221.sh"
    "ncurses-6.6.sh"
)
PACKAGES_4=(
    "nano-9.0.sh"
    "python-3.14.4.sh"
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
