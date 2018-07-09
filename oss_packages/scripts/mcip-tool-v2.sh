#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="mcip-tool-2"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://github.com/insys-icom/mcip-tool/archive/v2.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="85b882e69fad94f834020086bddddf83"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
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

    make "${M3_MAKEFLAGS}" \
         CC="${M3_CROSS_COMPILE}gcc" \
         CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
         LDFLAGS="-L${STAGING_LIB}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp "mcip-tool" "${STAGING_DIR}/bin" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

uninstall_staging()
{
    rm "${STAGING_DIR}/bin/mcip-tool"
}

. ${HELPERSDIR}/call_functions.sh
