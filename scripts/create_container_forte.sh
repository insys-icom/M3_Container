#!/bin/sh

DESCRIPTION="A container with the 4DIAC-Runtime called FORTE"
CONTAINER_NAME="container_forte"
ROOTFS_LIST="forte.txt"
exit 0
PACKAGES="${PACKAGES} Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES} busybox-1.24.2.sh"
PACKAGES="${PACKAGES} finit-1.10.sh"
PACKAGES="${PACKAGES} zlib-1.2.11.sh"
PACKAGES="${PACKAGES} dropbear-2016.74.sh"
PACKAGES="${PACKAGES} timezone2017b.sh"
PACKAGES="${PACKAGES} mcip.sh"
PACKAGES="${PACKAGES} pcre-8.38.sh"
PACKAGES="${PACKAGES} metalog-3.sh"
PACKAGES="${PACKAGES} openssl-1.0.2k.sh"
PACKAGES="${PACKAGES} libxml2-2.9.4.sh"
PACKAGES="${PACKAGES} sqlite-src-3110100.sh"
PACKAGES="${PACKAGES} gdbm-1.12.sh"
PACKAGES="${PACKAGES} lighttpd-1.4.39.sh"
PACKAGES="${PACKAGES} web_interface_forte-1.0.sh"
PACKAGES="${PACKAGES} app_handler-1.0.sh"
PACKAGES="${PACKAGES} c-ares-1.12.0.sh"
PACKAGES="${PACKAGES} libmodbus-3.0.6.sh"
PACKAGES="${PACKAGES} libmrx_control-1.0.sh"
PACKAGES="${PACKAGES} libFORTEControls-1.0.sh"
PACKAGES="${PACKAGES} paho.mqtt.c.sh"
PACKAGES="${PACKAGES} forte-1.8.4.sh"

SCRIPTSDIR="$(dirname $0)"
TOPDIR="$(realpath ${SCRIPTSDIR}/..)"
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo " "
echo "###################################################################################################"
echo " This creates a container with the mosquitto MQTT broker in it."
echo " Within the container will start an SSH server for logins. Both user name and password is \"root\"."
echo "###################################################################################################"
echo " "
echo "It is necessary to build these Open Source projects in this order:"
for PACKAGE in ${PACKAGES} ; do echo "- ${PACKAGE}"; done
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " # ./scripts/mk_container.sh -n ${CONTAINER_NAME} -l ${ROOTFS_LIST}"
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

SCRIPTSDIR="$(dirname $0)"
TOPDIR="$(realpath ${SCRIPTSDIR}/..)"
. ${TOPDIR}/scripts/common_settings.sh

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
