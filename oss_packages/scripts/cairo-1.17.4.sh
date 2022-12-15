#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="cairo-1.17.4"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://cairographics.org/snapshots/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="bf9d0d324ecbd350d0e9308125fa4ce0"



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
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    ax_cv_c_float_words_bigendian=no ./configure \
        LD_LIBRARY_PATH="${STAGING_LIB}" \
        LT_SYS_LIBRARY_PATH="${STAGING_LIB}" \
        png_REQUIRES="libpng" \
        png_CFLAGS="-I${STAGING_INCLUDE}" \
        png_LIBS="-L${STAGING_LIB}" \
        pixman_CFLAGS="-I${STAGING_INCLUDE}/pixman-1" \
        pixman_LIBS="-L${STAGING_LIB}" \
        CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
        CPPFLAGS="-I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -lpng -lpixman-1 -lfontconfig -lfreetype -lexpat" \
        FONTCONFIG_CFLAGS="-I${STAGING_INCLUDE}/fontconfig" \
        FONTCONFIG_LIBS="-L${STAGING_LIB}" \
        FREETYPE_CFLAGS="-I${STAGING_INCLUDE}/freetype2" \
        FREETYPE_LIBS="-L${STAGING_LIB}" \
        --with-sysroot="${STAGING_DIR}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="" \
        || exit_failure "failed to configure ${PKG_DIR}"
}
# LIBS="-lpng -lpixman-1 -lfontconfig -lfreetype -lexpat"
compile()
{
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
