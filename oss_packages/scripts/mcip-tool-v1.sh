#!/bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://github.com/insys-icom/mcip-tool/archive/v1.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="99da785f28de5eaa7ca03c36cb69984c"

# name of directory after extracting the archive in working directory
PKG_DIR="mcip-tool-1"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

SCRIPTSDIR="$(dirname $0)"
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR="$(realpath ${SCRIPTSDIR}/../..)"

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    true
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"

    export CC="${M3_CROSS_COMPILE}gcc"
    export CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}"
    export LDFLAGS="-L${STAGING_LIB}"

    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp "mcip-tool" "${STAGING_DIR}/bin"
}

uninstall_staging()
{
    rm "${STAGING_DIR}/bin/mcip-tool"
}

. ${HELPERSDIR}/call_functions.sh
