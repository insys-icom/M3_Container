#!/bin/sh

DESCRIPTOR="A container to demonstrate a modbus to mqtt gateway"
CONTAINER_NAME="Modbus_to_MQTT_Gateway"
ROOTFS_LIST="modbus_mqtt_gateway.txt"

echo "This creates a container with a modbus to mqtt gateway in it"
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
echo "- web_interface_modbus_mqtt_gateway-0.1.sh"
echo "- app_handler-0.1.sh"
echo "- libmodbus-3.1.4.sh"
echo "- mosquitto-1.4.10.sh"
echo "- modbus_to_mqtt_gateway-0.1.sh"
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
${OSS_PACKAGES_SCRIPTS}/timezone2016e.sh all
${OSS_PACKAGES_SCRIPTS}/mcip.sh all
${OSS_PACKAGES_SCRIPTS}/pcre-8.38.sh all
${OSS_PACKAGES_SCRIPTS}/metalog-3.sh all
${OSS_PACKAGES_SCRIPTS}/openssl-1.0.2h.sh all
${OSS_PACKAGES_SCRIPTS}/libxml2-2.9.4.sh all
${OSS_PACKAGES_SCRIPTS}/sqlite-src-3110100.sh all
${OSS_PACKAGES_SCRIPTS}/gdbm-1.12.sh all
${OSS_PACKAGES_SCRIPTS}/lighttpd-1.4.39.sh all
${OSS_PACKAGES_SCRIPTS}/web_interface_modbus_to_mqtt_gateway-0.1.sh all
${OSS_PACKAGES_SCRIPTS}/app_handler-0.1.sh all
${OSS_PACKAGES_SCRIPTS}/c-ares-1.12.0.sh all
${OSS_PACKAGES_SCRIPTS}/libmodbus-3.1.4.sh all
${OSS_PACKAGES_SCRIPTS}/mosquitto-1.4.10.sh all
${OSS_PACKAGES_SCRIPTS}/modbus_to_mqtt_gateway-0.1.sh all

# package container
echo " "
echo "Packaging the container"
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
