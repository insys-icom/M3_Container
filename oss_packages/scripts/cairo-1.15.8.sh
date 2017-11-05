#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="cairo-1.15.8"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="http://cairographics.org/snapshots/cairo-1.15.8.tar.xz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="e9cd63849e4792ec403fb6de78cfd9dd"



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
    ax_cv_c_float_words_bigendian=no ./configure \
        PKG_CONFIG_LIBDIR="${STAGING_LIB}/pkgconfig" \
        PKG_CONFIG="pkg-config" \
        png_CFLAGS="-I${STAGING_INCLUDE}" \
        png_LIBS="-L${STAGING_LIB}" \
        pixman_CFLAGS="-I${STAGING_INCLUDE}/pixman-1" \
        pixman_LIBS="-L${STAGING_LIB}" \
        CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
        CPPFLAGS="-L${STAGING_LIB} -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -lpng -lpixman-1" \
        --with-sysroot="${STAGING_DIR}" \
        --libdir="${STAGING_DIR}" \
        --enable-png=yes \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
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
