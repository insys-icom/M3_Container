#!/bin/sh

DESCRIPTION="An encrypted container with only busybox in it"
CONTAINER_NAME="container_busybox_encrypted"
ROOTFS_LIST="busybox.txt"
KEYFILE="busybox_encrypted.key"

PACKAGES="${PACKAGES} Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES} busybox-1.30.1.sh"

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo " "
echo "###################################################################################################"
echo " This creates an encrypted container that only contains busybox."
echo " Within the container will start a telnet server for logins. Both user name and password is \"root\"."
echo "###################################################################################################"
echo " "
echo "Note: The key to ecrypt the container (-k option) is stored in scripts/keys/<key>".
echo "      The key to decrypt the container must to be imported into the router (menu "
echo "      \"administration -> certificates\") before the container can be imported "
echo "      into the router. It is stored in scripts/keys/<key>.router."
echo " "
echo "It is necessary to build these Open Source projects in this order:"
for PACKAGE in ${PACKAGES} ; do echo "- ${PACKAGE}"; done
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " $ ./scripts/mk_container.sh -n \"${CONTAINER_NAME}\" -l \"${ROOTFS_LIST}\" -k \"${KEYFILE}\" -d \"${DESCRIPTION}\" -v \"1.0\""
echo " where the options -n and -l are mandatory."
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

# compile the needed packages
for PACKAGE in ${PACKAGES} ; do
    echo ""
    echo "*************************************************************************************"
    echo "* downloading, checking, configuring, compiling and installing ${PACKAGE%.sh}"
    echo "*************************************************************************************"
    echo ""
    ${OSS_PACKAGES_SCRIPTS}/${PACKAGE} all || exit
done

# package container
echo ""
echo "*************************************************************************************"
echo "* Packaging the container"
echo "*************************************************************************************"
echo ""
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -k "${KEYFILE}" -d "${DESCRIPTION}" -v "1.0"
