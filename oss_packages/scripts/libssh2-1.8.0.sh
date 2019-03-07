#!/bin/sh
# name of directory after extracting the archive in working directory
PKG_DIR="libssh2-1.8.0"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://github.com/libssh2/libssh2/archive/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="f55867a29927b3df4cbf904184343b25"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/libssh2-${PKG_DIR}"
PKG_HEADERS_DIR="${BUILD_DIR}/libssh2-${PKG_DIR}/include"
STAGING_INC_DIR="${STAGING_DIR}/include/libssh2"
STAGING_LIB_DIR="${STAGING_DIR}/lib"

configure()
{
    cd "${PKG_BUILD_DIR}"
    mkdir -p "${PKG_BUILD_DIR}/m3build/"
    ./buildconf
    ./configure PKG_CONFIG=pkg-config \
                PKG_CONFIG_LIBDIR="${STAGING_LIB}/pkgconfig" \
                CFLAGS="${M3_CFLAGS}" \
                LDFLAGS="${M3_LDFLAGS}" \
                CPPFLAGS="-I${STAGING_INCLUDE}" \
                --target="${M3_TARGET}" \
                --prefix="${PKG_BUILD_DIR}/m3build" \
                --host="${M3_TARGET}" \
                --with-libssl-prefix="${STAGING_DIR}" \
                --with-libz-prefix="${STAGING_DIR}" || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make clean;
    make ${M3_MAKEFLAGS} CFLAGS="${M3_CFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make install
}

install_staging()
{
    mkdir -p "${STAGING_INC_DIR}"
    cp -a "${PKG_BUILD_DIR}/m3build/lib/libssh2.s"* "${STAGING_LIB_DIR}"
    cp -a "${PKG_HEADERS_DIR}/libssh"* "${STAGING_INC_DIR}"
}

uninstall_staging()
{
    rm -rf "${STAGING_LIB_DIR}/libssh2"*
    rm -Rf "${STAGING_INC_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
