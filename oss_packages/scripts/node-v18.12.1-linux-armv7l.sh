#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="node-v18.12.1-linux-armv7l"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://nodejs.org/dist/v16.14.2/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="74a0350d24b16f3e4bda3e261648c8cc"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
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
    true
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp -a bin/node "${STAGING_DIR}/bin"
    cp -a lib/* "${STAGING_LIB}"
}

uninstall_staging()
{
    cd "${STAGING_DIR}"
    rm -Rf bin/node
    rm -Rf "${STAGING_LIB}/node_modules}"
}

. ${HELPERSDIR}/call_functions.sh
