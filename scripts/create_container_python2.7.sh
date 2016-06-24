#!/bin/sh

echo "This creates a container that only contains busybox"
echo ""
echo "It is necessary to build these Open Source projects in this order:"
echo "- Linux-PAM-1.2.1.sh"
echo "- busybox-1.24.2.sh"
echo "- finit-1.10.sh"
echo "- zlib-1.2.8.sh"
echo "- dropbear-2016.73.sh"
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
echo "- python-2.7.11.sh"
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo " # scripts/mk_container.sh -n busybox_container -l busybox.txt"
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" ] && exit 0

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh

# compile the needed packages
${OSS_PACKAGES_SCRIPTS}/Linux-PAM-1.2.1.sh all
${OSS_PACKAGES_SCRIPTS}/busybox-1.24.2.sh all
${OSS_PACKAGES_SCRIPTS}/finit-1.10.sh all
${OSS_PACKAGES_SCRIPTS}/zlib-1.2.8.sh all
${OSS_PACKAGES_SCRIPTS}/dropbear-2016.73.sh all
${OSS_PACKAGES_SCRIPTS}/mcip.sh all
${OSS_PACKAGES_SCRIPTS}/pcre-8.38.sh all
${OSS_PACKAGES_SCRIPTS}/metalog-3.sh all
${OSS_PACKAGES_SCRIPTS}/expat-2.2.0.sh all
${OSS_PACKAGES_SCRIPTS}/gdbm-1.12.sh all
${OSS_PACKAGES_SCRIPTS}/libffi-3.2.1.sh all
${OSS_PACKAGES_SCRIPTS}/ncurses-6.0.sh all
${OSS_PACKAGES_SCRIPTS}/openssl-1.0.2h.sh all
${OSS_PACKAGES_SCRIPTS}/readline-6.3.sh all
${OSS_PACKAGES_SCRIPTS}/sqlite-src-3110100.sh all
${OSS_PACKAGES_SCRIPTS}/python-2.7.11.sh all

# package container
echo " "
echo "Packaging the container"
DESCRIPTION="A container with only busybox in it"
${TOPDIR}/scripts/mk_container.sh -n busybox_container -l busybox.txt -d "${DESCRIPTION}" -v "1.0"
