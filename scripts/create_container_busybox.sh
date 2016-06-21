#!/bin/sh

echo "This creates a container that only contains busybox"
echo ""
echo "It is necessary to build these Open Source projects in this order:"
echo "- Linux-PAM-1.2.1.sh"
echo "- busybox-1.24.2.sh"
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " # scripts/mk_container.sh -n busybox_container -l busybox.txt"
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" ] && exit 0

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh

# compile the needed packages
${OSS_PACKAGES_SCRIPTS}/Linux-PAM-1.2.1.sh all
${OSS_PACKAGES_SCRIPTS}/busybox-1.24.2.sh all

# package container
echo " "
echo "Packaging the container"
DESCRIPTION="A container with only busybox in it"
${TOPDIR}/scripts/mk_container.sh -n busybox_container -l busybox.txt -d "${DESCRIPTION}" -v "1.0"
