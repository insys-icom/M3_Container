#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="nano-8.6"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://www.nano-editor.org/dist/v8/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="f7abfbf0eed5f573ab51bd77a458f32d82f9859c55e9689f819d96fe1437a619"



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
    CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_DIR}/usr/include" \
    CPPFLAGS="${M3_CFLAGS} -I${STAGING_DIR}/usr/include" \
    NCURSES_LIBS="-L${STAGING_DIR}/lib -lncurses -ltinfow" \
    NCURSES_CFLAGS="-I${STAGING_DIR}/include/ncurses" \
    NCURSESW_LIBS="-L${STAGING_DIR}/lib -lncursesw -ltinfow" \
    NCURSESW_CFLAGS="-I${STAGING_DIR}/include/ncursesw" \
    ./configure \
        gl_cv_func_strcasecmp_works=yes \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --disable-largefile \
        --disable-nls \
        --disable-rpath \
        --disable-extra \
        --disable-mouse \
        --disable-speller \
        --enable-year2038 \
        --datarootdir="/usr/share" \
        --enable-cross-guesses=conservative \
        --enable-utf8 || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
    cp "${PKG_BUILD_DIR}/doc/sample.nanorc" "${STAGING_DIR}/etc/"
}

. ${HELPERSDIR}/call_functions.sh
