#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="lz4-1.7.5"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# https://github.com/lz4/lz4/archive/v1.7.5.tar.gz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="c9610c5ce97eb431dddddf0073d919b9"



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
    cd "${PKG_BUILD_DIR}"
    export CC="${M3_CROSS_COMPILE}"gcc
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    ./configure --target="${M3_TARGET}" --host="${M3_TARGET}" --prefix=""
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp "${PKG_INSTALL_DIR}/usr/local/lib/liblz4.so"* "${STAGING_DIR}/lib"
    cp "${PKG_INSTALL_DIR}/usr/local/include/lz4.h"* "${STAGING_DIR}/include"
}

uninstall_staging()
{
    rm -rf "${STAGING_DIR}/lib/liblz4.so"*
    rm -rf "${STAGING_DIR}/include/lz4.h"
}

. ${HELPERSDIR}/call_functions.sh
