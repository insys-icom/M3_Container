#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="bzip2-1.0.8"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://sourceware.org/pub/bzip2/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="67e051268d0c475ea773822f7500d0e5"



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
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cp "${PKG_BUILD_DIR}/libbz2.a" "${STAGING_LIB}"
    cp "${PKG_BUILD_DIR}/bzlib.h" "${STAGING_INCLUDE}"
    cp "${PKG_BUILD_DIR}/bzip2" "${STAGING_DIR}/bin"
    cp "${PKG_BUILD_DIR}/bzip2recover" "${STAGING_DIR}/bin"
}

uninstall_staging()
{
    rm -rf "${STAGING_LIB}/libbz2.a"
    rm -rf "${STAGING_LIB}/bzlib.h"
    rm -rf "${STAGING_LIB}/bzip2"
    rm -rf "${STAGING_LIB}/bzip2recover"
}

. ${HELPERSDIR}/call_functions.sh
