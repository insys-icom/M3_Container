#!/bin/sh

[ "$1" == "do_nothing" ] && return

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
. "${TOPDIR}"/scripts/common_settings.sh
. "${TOPDIR}"/scripts/helpers.sh

package() {
    echo ""
    echo "Packaging the container:"
    echo "--------------------------------------------"
    ${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
}

if ! [ "$1" == "do_not_package" ] ; then
    echo " "
    echo "It is necessary to build these Open Source projects in this order:"
    for PACKAGE in ${PACKAGES_1} ; do echo "- ${PACKAGE}"; done
    for PACKAGE in ${PACKAGES_2} ; do echo "- ${PACKAGE}"; done
    for PACKAGE in ${PACKAGES_3} ; do echo "- ${PACKAGE}"; done
    for PACKAGE in ${PACKAGES_4} ; do echo "- ${PACKAGE}"; done
    echo " "
    echo "These packages only have to be compiled once. After that you can choose to only pack the container. Choose:"
    echo "    b --- build all sources and pack the container"
    echo "    p --- pack the container without building the sources"
    echo "    c --- cancel, do nothing"
    echo ""

    read input
    case "${input}" in
        p)    package; exit 0;;
        b|y)  echo "Building everything";;
        c|*)  echo "Exiting"; exit 0;;
    esac
    #! [ "${input}" = "y" -o "${input}" = "yes" ] && exit 0
fi
cd "${TOPDIR}"/rootfs_staging
mkdir -p bin etc include lib libexec sbin share ssl usr var
cd "${TOPDIR}"/

# get rid of previous log file
rm -rf "${BUILD_DIR}/${PACKAGE}.log"

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
download ${PACKAGES_4}

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
uninstall ${PACKAGES_4}

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
echo "    ----------------------------------------"
compile ${PACKAGES_4}
wait || exit_failure "Failed to build PACKAGES_4"

# package container
if ! [ "$1" == "do_not_package" ] ; then
    package
fi
