#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="nettle-3.2"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="afb15b4764ebf1b4e6d06c62bd4d29e4"



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
    export CFLAGS="${M3_CFLAGS}"
    export LDFLAGS="${M3_LDFLAGS}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix="" --disable-shared --enable-arm-neon --enable-mini-gmp --with-lib-path=${STAGING_LIB} --with-include-path=${STAGING_INCLUDE}
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} PREFIX=/ CC="${M3_CROSS_COMPILE}gcc" CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" || exit_failure "failed to build ${PKG_DIR}"

    make PREFIX=/ DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make PREFIX=/ DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
