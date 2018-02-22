#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="mpop-1.2.6"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://sourceforge.net/projects/mpop/files/latest/download?source=files"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="2298ddcf1defbf8e7097a1869c8d39d3"



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
    CROSS_COMPILE="${M3_CROSS_COMPILE}" \
    CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    libssl_LIBS="-lssl -lcrypto" \
    libssl_CFLAGS="-I${STAGING_INCLUDE} -L${STAGING_LIB}" \
    ./configure --target="${M3_TARGET}" \
                --host="${M3_TARGET}" \
                --disable-nls \
                --with-tls=openssl \
                --prefix="" || exit_failure "failed to configure ${PKG_DIR}"
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
