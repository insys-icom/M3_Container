#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="finit-1.10"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="c41d53e8bc776f2cee133b35ea95719a"



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
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    PLUGINS="initctl.so" CC="${M3_CROSS_COMPILE}gcc" CROSS="${M3_CROSS_COMPILE}" CFLAGS="${M3_CFLAGS}" LDFLAGS="${M3_LDFLAGS}" DESTDIR="${PKG_INSTALL_DIR}" make DEPLIBS="libite/libite.a" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp -a "${PKG_INSTALL_DIR}/etc" "${STAGING_DIR}/"
    cp -a "${PKG_INSTALL_DIR}/lib" "${STAGING_DIR}/"
    cp -a "${PKG_INSTALL_DIR}/usr" "${STAGING_DIR}/"
    cp -a "${PKG_INSTALL_DIR}/sbin" "${STAGING_DIR}/"
}

. ${HELPERSDIR}/call_functions.sh
