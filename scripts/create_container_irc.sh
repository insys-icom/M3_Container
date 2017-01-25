#!/bin/sh

DESCRIPTION="A container with the Internet Relay Chat server (ngircd)"
CONTAINER_NAME="irc_container"
ROOTFS_LIST="irc.txt"

SCRIPTSDIR="$(dirname $0)"
TOPDIR="$(realpath ${SCRIPTSDIR}/..)"
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo "This creates a container with the IRC server \"ngircd\"."
echo "Within the container will start an SSH server for logins. Both user name and password is \"root\"."
echo ""
echo "It is necessary to build these Open Source projects in this order:"
echo "- Linux-PAM-1.2.1.sh"
echo "- busybox-1.24.2.sh"
echo "- finit-1.10.sh"
echo "- zlib-1.2.11.sh"
echo "- dropbear-2016.73.sh"
echo "- openssl-1.0.2h.sh"
echo "- timezone2016e.sh"
echo "- ngircd-23.sh"
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " $ ./scripts/mk_container.sh -n \"${CONTAINER_NAME}\" -l \"${ROOTFS_LIST}\"  -d \"${DESCRIPTION}\" -v \"1.0\""
echo " where the options -n and -l are mandatory."
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

PACKAGES="${PACKAGES}  Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES}  busybox-1.24.2.sh"
PACKAGES="${PACKAGES}  finit-1.10.sh"
PACKAGES="${PACKAGES}  zlib-1.2.11.sh"
PACKAGES="${PACKAGES}  dropbear-2016.73.sh"
PACKAGES="${PACKAGES}  openssl-1.0.2h.sh"
PACKAGES="${PACKAGES}  timezone2016e.sh"
PACKAGES="${PACKAGES}  ngircd-23.sh"

# compile the needed packages
for PACKAGE in ${PACKAGES} ; do
    echo ""
    echo "*************************************************************************************"
    echo "* downloading, checking, configuring, compiling and installing ${PACKAGE%.sh}"
    echo "*************************************************************************************"
    echo ""
    ${OSS_PACKAGES_SCRIPTS}/${PACKAGE}          all || exit
done

# package container
echo ""
echo "*************************************************************************************"
echo "* Packaging the container"
echo "*************************************************************************************"
echo ""
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
