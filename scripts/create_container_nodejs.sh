#!/bin/sh

DESCRIPTION="Container with NodeJS in it"
CONTAINER_NAME="container_nodejs"
ROOTFS_LIST="rootfs_list_nodejs.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.12.sh
    lz4-1.9.3.sh
    timezone2022a.sh
    pcre2-10.39.sh
    openssl-1.1.1n.sh
    c-ares-1.18.1.sh
    cacert-2022-03-29.sh
    nghttp2-1.47.0.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    dropbear-2022.82.sh
    metalog-20220214.sh
    dnsmasq-2.86.sh
    libssh2-1.10.0.sh
    ncurses-6.3.sh
    mcip-tool-v2.sh
"

PACKAGES_3="
    curl-7.82.0.sh
    nano-6.2.sh
    node-v16.14.2-linux-armv7l.sh
"

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. ${TOPDIR}/scripts/common_settings.sh
. ${TOPDIR}/scripts/helpers.sh

echo " "
echo "It is necessary to build these Open Source projects in this order:"
for PACKAGE in ${PACKAGES_1} ; do echo "- ${PACKAGE}"; done
for PACKAGE in ${PACKAGES_2} ; do echo "- ${PACKAGE}"; done
for PACKAGE in ${PACKAGES_3} ; do echo "- ${PACKAGE}"; done
echo " "
echo "These packages only have to be compiled once. After that you can package the container yourself with"
echo "    ./scripts/mk_container.sh -n \"${CONTAINER_NAME}\" -l \"${ROOTFS_LIST}\" -d \"${DESCRIPTION}\" -v \"1.0\""
echo " where the options -n and -l are mandatory."
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

cd rootfs_staging
mkdir -p bin etc include lib libexec sbin share ssl usr var
cd ..

# get rid of previous log file
rm "${BUILD_DIR}/${PACKAGE}.log"

# download all required packages
echo " "
echo "Downloading packages:"
echo "--------------------------------------------"
download() {
    for PACKAGE in ${@} ; do
        echo "    Downloading ${PACKAGE}"
        ${OSS_PACKAGES_SCRIPTS}/${PACKAGE} download > "${BUILD_DIR}/${PACKAGE}.log" 2>&1 || exit_failure "Could not download ${PACKAGE}"
    done
}
download ${PACKAGES_1}
download ${PACKAGES_2}
download ${PACKAGES_3}

# uninstall everything
echo " "
echo "Uninstalling packages:"
echo "--------------------------------------------"
uninstall() {
    for PACKAGE in ${@} ; do
        echo "    Uninstall ${PACKAGE}"
        ${OSS_PACKAGES_SCRIPTS}/${PACKAGE} uninstall_staging >> "${BUILD_DIR}/${PACKAGE}.log" 2>&1 || exit_failure "Could not download ${PACKAGE}"
    done
}
uninstall ${PACKAGES_1}
uninstall ${PACKAGES_2}
uninstall ${PACKAGES_3}

# compile
compile() {
    for PACKAGE in ${@} ; do
        echo "    Compile ${PACKAGE}"
        ${OSS_PACKAGES_SCRIPTS}/${PACKAGE} all > "${BUILD_DIR}/${PACKAGE}.log" 2>&1 &
    done
}

echo " "
echo "Compiling in parallel:"
echo "--------------------------------------------"
compile ${PACKAGES_1}
wait || exit_failure "Failed to build PACKAGES_1"
echo "    ----------------------------------------"
compile ${PACKAGES_2}
wait || exit_failure "Failed to build PACKAGES_2"
echo "    ----------------------------------------"
compile ${PACKAGES_3}
wait || exit_failure "Failed to build PACKAGES_3"

# package container
echo ""
echo "Packaging the container:"
echo "--------------------------------------------"
${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
