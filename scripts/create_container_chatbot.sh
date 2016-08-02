#!/bin/sh

DESCRIPTION="A container with an IRC chatbot (energymech)"
CONTAINER_NAME="chatbot_container"
ROOTFS_LIST="chatbot.txt"

echo "This creates a minimalistic container with the IRC chatbot \"energymech\""
echo ""
echo "It is necessary to build these Open Source projects in this order:"
echo "- busybox-1.24.2_mini.sh"
echo "- energymech-master.sh"
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
${OSS_PACKAGES_SCRIPTS}/busybox-1.24.2_mini.sh all
${OSS_PACKAGES_SCRIPTS}/energymech-master.sh all

# package container
echo " "
echo "Packaging the container"
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
