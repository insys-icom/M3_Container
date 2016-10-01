#!/bin/sh

DESCRIPTION="A container with an IRC chatbot (energymech)"
CONTAINER_NAME="chatbot_container"
ROOTFS_LIST="chatbot.txt"

SCRIPTSDIR="$(dirname $0)"
TOPDIR="$(realpath ${SCRIPTSDIR}/..)"
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo "This creates a minimalistic container with the IRC chatbot \"energymech\"."
echo "Within the container will start a telnet server for logins. Both user name and password is \"root\"."
echo ""
echo "It is necessary to build these Open Source projects in this order:"
echo "- busybox-1.24.2_mini.sh"
echo "- energymech-master.sh"
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " $ ./scripts/mk_container.sh -n \"${CONTAINER_NAME}\" -l \"${ROOTFS_LIST}\" -d \"${DESCRIPTION}\" -v \"1.0\""
echo " where the options -n and -l are mandatory."
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

PACKAGES="${PACKAGES}  busybox-1.24.2_mini.sh"
PACKAGES="${PACKAGES}  energymech-master.sh"

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
