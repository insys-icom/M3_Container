#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="httping-2.5"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tgz"

# download link for the sources to be stored in dl directory
# https://www.vanheusden.com/httping/httping-2.5.tgz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="a92976c06af8b80af17f70f0cb059bdc"



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
    cd "${PKG_BUILD_DIR}"
    export CC="${M3_CROSS_COMPILE}gcc"
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"

    # do not use transation files
    sed -i "s@TRANSLATIONS=nl.mo ru.mo@#TRANSLATIONS=nl.mo ru.mo@" Makefile

    # fake translation files
    touch nl.mo ru.mo
    ./configure --with-openssl --with-tfo
}

compile()
{
    copy_overlay
    export CC="${M3_CROSS_COMPILE}gcc"
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    export DEBUG="no"
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
