#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="metalog-20260811"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://github.com/hvisage/metalog/archive/refs/tags/${PKG_ARCHIVE_FILE#*-}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="6d6f38617927896139f54819cdda4a9f8fe56f5de80fd9b59adefb3478a23729"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}"/scripts/common_settings.sh
. "${HELPERSDIR}"/functions.sh
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    ./autogen.sh
    ./configure \
        CFLAGS="${M3_CFLAGS}" \
        LDFLAGS="${M3_LDFLAGS}" \
        PCRE2_CFLAGS="-I${STAGING_INCLUDE}" \
        PCRE2_LIBS="-L${STAGING_LIB} -lpcre2-8" \
        ZLIB_CFLAGS="-I${STAGING_INCLUDE}" \
        ZLIB_LIBS="-L${STAGING_LIB} -lz" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="" \
        --with-compress \
        --with-unicode \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
