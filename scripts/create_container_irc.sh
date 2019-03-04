#!/bin/sh

DESCRIPTION="A container with the Internet Relay Chat server (ngircd)"
CONTAINER_NAME="container_irc"
ROOTFS_LIST="irc.txt"

PACKAGES="${PACKAGES} Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES} busybox-1.30.1.sh"
PACKAGES="${PACKAGES} finit-1.10.sh"
PACKAGES="${PACKAGES} zlib-1.2.11.sh"
PACKAGES="${PACKAGES} dropbear-2018.76.sh"
PACKAGES="${PACKAGES} openssl-1.0.2r.sh"
PACKAGES="${PACKAGES} timezone2018i.sh"
PACKAGES="${PACKAGES} mcip.sh"
PACKAGES="${PACKAGES} mcip-tool-v2.sh"
PACKAGES="${PACKAGES} ngircd-24.sh"

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo " "
echo "###################################################################################################"
echo " This creates a container with the IRC server \"ngircd\"."
echo " Within the container will start an SSH server for logins. Both user name and password is \"root\"."
echo "###################################################################################################"
echo " "
echo "It is necessary to build these Open Source projects in this order:"
for PACKAGE in ${PACKAGES} ; do echo "- ${PACKAGE}"; done
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " $ ./scripts/mk_container.sh -n \"${CONTAINER_NAME}\" -l \"${ROOTFS_LIST}\"  -d \"${DESCRIPTION}\" -v \"1.0\""
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
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
