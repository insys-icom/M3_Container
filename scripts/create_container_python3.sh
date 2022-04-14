#!/bin/sh

DESCRIPTION="Container running Pyhton 3"
CONTAINER_NAME="container_python3"
ROOTFS_LIST="rootfs_list_python3.txt"

PACKAGES_1="
    Linux-PAM-1.5.2.sh
    zlib-1.2.12.sh
    bzip2-1.0.8.sh
    lz4-1.9.3.sh
    timezone2022a.sh
    pcre2-10.39.sh
    openssl-1.1.1n.sh
    libuuid-1.0.3.sh
    expat-2.4.1.sh
    libffi-3.4.2.sh
    xz-5.2.5.sh
    cacert-2022-03-29.sh
    python_modules-2022-03-31.sh
    mcip.sh
"

PACKAGES_2="
    busybox-1.34.1.sh
    dropbear-2022.82.sh
    sqlite-src-3380200.sh
    metalog-20220214.sh
    ncurses-6.3.sh
    mcip-tool-v2.sh
"

PACKAGES_3="
    nano-6.2.sh
    python-3.10.4.sh
    get-pip-22.0.4.sh
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
