#!/bin/sh

DESCRIPTION="A container with Python 2.7 in it"
CONTAINER_NAME="python_2.7_container"
ROOTFS_LIST="python_2.7.txt"

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo "This creates a container that only contains busybox"
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
echo "- metalog-3.sh"
echo "- expat-2.2.0.sh"
echo "- gdbm-1.12.sh"
echo "- libffi-3.2.1.sh"
echo "- ncurses-6.0.sh"
echo "- openssl-1.0.2h.sh"
echo "- readline-6.3.sh"
echo "- sqlite-src-3110100.sh"
echo "- python-2.7.12.sh"
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " > ./scripts/mk_container.sh -n \"${CONTAINER_NAME}\" -l \"${ROOTFS_LIST}\" -d \"${DESCRIPTION}\" -v \"1.0\""
echo " where the options -n and -l are mandatory."
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

PACKAGES="${PACKAGES}  Linux-PAM-1.2.1.sh"
PACKAGES="${PACKAGES}  busybox-1.24.2.sh"
PACKAGES="${PACKAGES}  finit-1.10.sh"
PACKAGES="${PACKAGES}  zlib-1.2.8.sh"
PACKAGES="${PACKAGES}  dropbear-2016.73.sh"
PACKAGES="${PACKAGES}  timezone2016e.sh"
PACKAGES="${PACKAGES}  mcip.sh"
PACKAGES="${PACKAGES}  pcre-8.38.sh"
PACKAGES="${PACKAGES}  metalog-3.sh"
PACKAGES="${PACKAGES}  expat-2.2.0.sh"
PACKAGES="${PACKAGES}  gdbm-1.12.sh"
PACKAGES="${PACKAGES}  libffi-3.2.1.sh"
PACKAGES="${PACKAGES}  ncurses-6.0.sh"
PACKAGES="${PACKAGES}  openssl-1.0.2h.sh"
PACKAGES="${PACKAGES}  readline-6.3.sh"
PACKAGES="${PACKAGES}  sqlite-src-3110100.sh"
PACKAGES="${PACKAGES}  python-2.7.12.sh"

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
