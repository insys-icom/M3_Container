#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="lz4-1.10.0"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://github.com/lz4/lz4/archive/refs/tags/v${PKG_ARCHIVE_FILE##*-}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="537512904744b35e232912055ccf8ec66d768639ff3abe5788d90d792ec5f48b"



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
    make DESTDIR="${PKG_INSTALL_DIR}" \
         CC="${M3_CROSS_COMPILE}"gcc \
         CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
         LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
         install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp "${PKG_INSTALL_DIR}/usr/local/lib/liblz4.so"* "${STAGING_DIR}/lib" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
    cp "${PKG_INSTALL_DIR}/usr/local/include/lz4.h"* "${STAGING_DIR}/include" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

uninstall_staging()
{
    rm -vrf "${STAGING_DIR}/lib/liblz4.so"*
    rm -vrf "${STAGING_DIR}/include/lz4.h"
}

. ${HELPERSDIR}/call_functions.sh
