#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="picocom-3.1"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://github.com/npat-efault/picocom/archive/3.1.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="b755ea852c0e9ac9d5e058d76003e21d"



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
    cd "${PKG_BUILD_DIR}"
    CC="${M3_CROSS_COMPILE}gcc" make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp picocom "${STAGING_DIR}/bin"
}

uninstall_staging()
{
    rm -vf "${STAGING_DIR}/bin/picocom"
}

. ${HELPERSDIR}/call_functions.sh
