#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="nghttp2-1.63.0"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory (use "none" if empty)
#PKG_DOWNLOAD="https://github.com/nghttp2/nghttp2/releases/download/v${PKG_DIR##*-}/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="4879c75dd32a74421b9857924449460b8341796c0613ba114ab2188e4622354b"



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
    ./configure \
        CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        OPENSSL_CFLAGS="-I${STAGING_INCLUDE}" \
        OPENSSL_LIBS="-lssl -lcrypto -L${STAGING_LIB}" \
        ZLIB_CFLAGS="-I${STAGING_INCLUDE}" \
        ZLIB_LIBS="-lz -L${STAGING_LIB}" \
        LIBCARES_CFLAGS="-I${STAGING_INCLUDE}" \
        LIBCARES_LIBS="-lcares -L${STAGING_LIB}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="" \
        --enable-lib-only \
        --enable-static \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" \
         install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
