#!/bin/sh

DESCRIPTION="A container with the Internet Relay Chat server (ngircd)"
CONTAINER_NAME="irc_container"
ROOTFS_LIST="irc.txt"

echo "This creates a container with the IRC server \"ngircd\""
echo ""
echo "It is necessary to build these Open Source projects in this order:"
echo "- Linux-PAM-1.2.1.sh"
echo "- busybox-1.24.2.sh"
echo "- finit-1.10.sh"
echo "- zlib-1.2.8.sh"
echo "- dropbear-2016.73.sh"
echo "- openssl-1.0.2h.sh"
echo "- timezone2016e.sh"
echo "- ngircd-23.sh"
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " # ./scripts/mk_container.sh -n ${CONTAINER_NAME} -l ${ROOTFS_LIST}"
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" ] && exit 0

SCRIPTSDIR="$(dirname $0)"
TOPDIR="$(realpath ${SCRIPTSDIR}/..)"
. ${TOPDIR}/scripts/common_settings.sh

# compile the needed packages
${OSS_PACKAGES_SCRIPTS}/Linux-PAM-1.2.1.sh all
${OSS_PACKAGES_SCRIPTS}/busybox-1.24.2.sh all
${OSS_PACKAGES_SCRIPTS}/finit-1.10.sh all
${OSS_PACKAGES_SCRIPTS}/zlib-1.2.8.sh all
${OSS_PACKAGES_SCRIPTS}/dropbear-2016.73.sh all
${OSS_PACKAGES_SCRIPTS}/openssl-1.0.2h.sh all
${OSS_PACKAGES_SCRIPTS}/timezone2016e.sh all
${OSS_PACKAGES_SCRIPTS}/ngircd-23.sh all

# package container
echo " "
echo "Packaging the container"
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
