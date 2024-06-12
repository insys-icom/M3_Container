#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="nmap-7.95"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://nmap.org/dist/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="e14ab530e47b5afd88f1c8a2bac7f89cd8fe6b478e22d255c5b9bddb7a1c5778"



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
        CROSS_COMPILE="${M3_CROSS_COMPILE}" \
        CFLAGS="${M3_CFLAGS}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --with-openssl="${STAGING_DIR}" \
        --with-libpcre=included \
        --with-libpcap=included \
        --with-liblua=included \
        --with-libssh2=included \
        --with-liblinear=included \
        --with-libdnet=included \
        --without-zenmap \
        --prefix="" \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
