#!/bin/sh

[ -n "${ARCH}" ] ||  ARCH="armv7"

TASK=""
SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)

usage()
{
    echo "Usage: create.sh [-a ARCHITECTURE] [-p] [-b]"
    echo "    -a  available architectures: \"amd64\", \"armv7\""
    echo "    -b  build all sources and pack the container"
    echo "    -p  pack the container without building the sources"
    echo ""
}

package() {
    echo ""
    echo "Packaging the container \"${CONTAINER_NAME}\" for ${ARCH}:"
    echo "------------------------------------------------------"
    ${TOPDIR}/scripts/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0" -a "${ARCH}"
}

# read all options from command line
get_options()
{
    while [ -n "${1}" ] ; do
        case "${1}" in
            "-a")
                shift
                export ARCH="${1}"
            ;;
            "-b")
                TASK="build"
            ;;
            "-p")
                [ "${TASK}" == "build" ] || TASK="package"
            ;;
            "-h")
                usage
                exit 0
            ;;
            *)
                usage
            ;;
        esac
        shift
    done
}

get_options "${@}"
. "${TOPDIR}"/scripts/common_settings.sh


if [ "${TASK}" == "package" ] ; then
    package
    exit 0
elif [ "${TASK}" == "build" ] ; then
    echo "Building everything for ${ARCH}"
else
    echo " "
    echo "It is necessary to build these Open Source projects in this order:"
    for i in "${PACKAGES[@]}"; do
        PACKAGE=("${!i}")
        for p in "${PACKAGE[@]}"; do
            echo "- ${p}"
        done
    done
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


# create a symlinks and directories in staging area
cd "${STAGING_DIR}"
mkdir -p bin etc include lib libexec sbin share ssl usr var
[ -e "lib64" ] || ln -s lib lib64
cd "${TOPDIR}"/

# download all required packages
echo " "
echo "Downloading packages:"
echo "------------------------------------------------------"
for i in "${PACKAGES[@]}"; do
    PACKAGE=("${!i}")
    for p in "${PACKAGE[@]}"; do
        rm -rf "${BUILD_DIR}/${p}.log" # get rid of previous log file
        echo "    Downloading ${p}"
        ${OSS_PACKAGES_SCRIPTS}/${p} download > "${BUILD_DIR}/${p}.log" 2>&1 || exit_failure "Could not download ${p}"
    done
done

# uninstall everything
echo " "
echo "Uninstalling packages:"
echo "------------------------------------------------------"
for i in "${PACKAGES[@]}"; do
    PACKAGE=("${!i}")
    for p in "${PACKAGE[@]}"; do
        echo "    Uninstall ${p}"
        ${OSS_PACKAGES_SCRIPTS}/${p} uninstall_staging >> "${BUILD_DIR}/${p}.log" 2>&1 || exit_failure "Could not uninstall ${p}"
    done
done

# compile OSS
echo " "
echo "Compiling in parallel for ${ARCH}:"
echo "------------------------------------------------------"
for i in "${PACKAGES[@]}"; do
    PACKAGE=("${!i}")
    for p in "${PACKAGE[@]}"; do
        echo "    Compile ${p}"
        ${OSS_PACKAGES_SCRIPTS}/${p} all > "${BUILD_DIR}/${p}.log" 2>&1 &
    done
    wait || exit_failure "Failed to build ${p}"
    echo "    --------------------------------------------------"
done

# compile closed source
echo ""
echo "Compiling closed packages:"
echo "------------------------------------------------------"
for i in "${CLOSED_PACKAGES[@]}"; do
    CLOSED_PACKAGE=("${!i}")
    for p in "${CLOSED_PACKAGE[@]}"; do
        echo "    Compile ${p}"
        ${CLOSED_PACKAGES_DIR}/${p} > "${BUILD_DIR}/${p}.log" 2>&1 &
    done
    wait || exit_failure "Failed to build ${p}"
    echo "    --------------------------------------------------"
done

# create the Update Packet
package
