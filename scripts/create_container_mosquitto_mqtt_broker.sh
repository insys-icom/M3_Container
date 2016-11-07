#!/bin/sh

DESCRIPTION="A container to demonstrate the mosquitto MQTT broker"
CONTAINER_NAME="Mosquitto_MQTT_Broker"
ROOTFS_LIST="mosquitto_mqtt_broker.txt"

SCRIPTSDIR="$(dirname $0)"
TOPDIR="$(realpath ${SCRIPTSDIR}/..)"
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo "This creates a container with the mosquitto MQTT broker in it."
echo "Within the container will start an SSH server for logins. Both user name and password is \"root\"."
echo ""
echo "It is necessary to build these Open Source projects in this order:"
echo "- Linux-PAM-1.2.1.sh"
echo "- busybox-1.24.2.sh"
echo "- finit-1.10.sh"
echo "- zlib-1.2.8.sh"
echo "- dropbear-2016.73.sh"
echo "- timezone2016e.sh"
echo "- mcip.sh"
echo "- pcre-8.38.sh"
echo "- openssl-1.0.2h.sh"
echo "- libxml2-2.9.4.sh"
echo "- sqlite-src-3110100.sh"
echo "- gdbm-1.12.sh"
echo "- lighttpd-1.4.39.sh"
echo "- c-ares-1.12.0.sh"
echo "- web_interface_mosquitto_mqtt_broker-1.0.sh"
echo "- app_handler-1.0.sh"
echo "- libmodbus-3.1.4.sh"
echo "- mosquitto-1.4.10.sh"
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

PACKAGES="${PACKAGES}  Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES}  busybox-1.24.2.sh"
PACKAGES="${PACKAGES}  finit-1.10.sh"
PACKAGES="${PACKAGES}  zlib-1.2.8.sh"
PACKAGES="${PACKAGES}  dropbear-2016.73.sh"
PACKAGES="${PACKAGES}  timezone2016e.sh"
PACKAGES="${PACKAGES}  mcip.sh"
PACKAGES="${PACKAGES}  pcre-8.38.sh"
PACKAGES="${PACKAGES}  metalog-3.sh"
PACKAGES="${PACKAGES}  openssl-1.0.2h.sh"
PACKAGES="${PACKAGES}  libxml2-2.9.4.sh"
PACKAGES="${PACKAGES}  sqlite-src-3110100.sh"
PACKAGES="${PACKAGES}  gdbm-1.12.sh"
PACKAGES="${PACKAGES}  lighttpd-1.4.39.sh"
PACKAGES="${PACKAGES}  web_interface_mosquitto_mqtt_broker-1.0.sh"
PACKAGES="${PACKAGES}  app_handler-1.0.sh"
PACKAGES="${PACKAGES}  c-ares-1.12.0.sh"
PACKAGES="${PACKAGES}  libmodbus-3.1.4.sh"
PACKAGES="${PACKAGES}  mosquitto-1.4.10.sh"

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
