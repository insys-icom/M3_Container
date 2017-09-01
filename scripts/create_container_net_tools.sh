#!/bin/sh

DESCRIPTION="A container with the tools to analyze networking"
CONTAINER_NAME="container_net_tools"
ROOTFS_LIST="net_tools.txt"

PACKAGES="${PACKAGES} Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES} busybox-1.24.2.sh"
PACKAGES="${PACKAGES} finit-1.10.sh"
PACKAGES="${PACKAGES} zlib-1.2.11.sh"
PACKAGES="${PACKAGES} libpcap-1.7.4.sh"
PACKAGES="${PACKAGES} libcap-2.25.sh"
PACKAGES="${PACKAGES} dropbear-2017.75.sh"
PACKAGES="${PACKAGES} openssl-1.0.2l.sh"
PACKAGES="${PACKAGES} timezone2017b.sh"
PACKAGES="${PACKAGES} iperf-2.0.9.sh"
PACKAGES="${PACKAGES} iputils-s20151218.sh"
PACKAGES="${PACKAGES} curl-7.54.1.sh"
PACKAGES="${PACKAGES} mcip.sh"
PACKAGES="${PACKAGES} mcip-tool-v1.sh"
PACKAGES="${PACKAGES} pcre-8.38.sh"
PACKAGES="${PACKAGES} metalog-3.sh"
PACKAGES="${PACKAGES} lz4-1.7.5.sh"
PACKAGES="${PACKAGES} lzo-2.09.sh"
PACKAGES="${PACKAGES} openvpn-2.4.3.sh"
PACKAGES="${PACKAGES} strace-4.16.sh"
PACKAGES="${PACKAGES} stunnel-5.41.sh"
PACKAGES="${PACKAGES} tcpdump-4.7.4.sh"
PACKAGES="${PACKAGES} iptables-1.6.0.sh"
PACKAGES="${PACKAGES} httping-2.5.sh"

SCRIPTSDIR="$(dirname $0)"
TOPDIR="$(realpath ${SCRIPTSDIR}/..)"
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
    ${OSS_PACKAGES_SCRIPTS}/${PACKAGE}          all || exit
done

# package container
echo ""
echo "*************************************************************************************"
echo "* Packaging the container"
echo "*************************************************************************************"
echo ""
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"