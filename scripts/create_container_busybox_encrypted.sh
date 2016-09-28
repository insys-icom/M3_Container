#!/bin/sh

DESCRIPTION="A container with only busybox in it"
CONTAINER_NAME="busybox_container_encrypted"
ROOTFS_LIST="busybox.txt"
KEYFILE="containerkeyfile"

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo "This creates an encrypted container that only contains busybox"
echo " "
echo "Note: The keyfile (-k option) will be generated automatically if it doesn't exist and stored under scripts/keys/<keyfile>"
echo "      The keyfile which has to be imported to the MRX to be able to use this encrypted container will be stored under"
echo "      scripts/keys/<keyfile>.router"
echo " "
echo "It is necessary to build these Open Source projects in this order:"
echo "- Linux-PAM-1.2.1.sh"
echo "- busybox-1.24.2.sh"
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " # ./scripts/mk_container.sh -n \"${CONTAINER_NAME}\" -l \"${ROOTFS_LIST}\" -k \"${KEYFILE}\" -d \"${DESCRIPTION}\" -v \"1.0\""
echo " where the options -n and -l are mandatory."
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

PACKAGES="${PACKAGES}  Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES}  busybox-1.24.2.sh"

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
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -k "${KEYFILE}" -d "${DESCRIPTION}" -v "1.0"
