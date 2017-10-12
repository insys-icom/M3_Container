#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="nettle-3.3"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://ftp.gnu.org/gnu/nettle/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="10f969f78a463704ae73529978148dbe"



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
    cd "${PKG_BUILD_DIR}"
    ./configure CFLAGS="${M3_CFLAGS}" \
                LDFLAGS="${M3_LDFLAGS}" \
                --target=${M3_TARGET} \
                --host=${M3_TARGET} \
                --prefix="" \
                --disable-shared \
                --enable-arm-neon \
                --enable-mini-gmp \
                --with-lib-path=${STAGING_LIB} \
                --with-include-path=${STAGING_INCLUDE}

    if [ $? -ne 0 ]; then
        exit_failure "failed to configure ${PKG_DIR}"
    fi
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} PREFIX=/ CC="${M3_CROSS_COMPILE}gcc" CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" || exit_failure "failed to build ${PKG_DIR}"

    make PREFIX=/ DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make PREFIX=/ DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
