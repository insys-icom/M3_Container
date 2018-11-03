#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="nano-3.1"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
# PKG_DOWNLOAD="https://www.nano-editor.org/dist/v3/nano-3.1.tar.xz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="e5cbe298e4362fabb7e55173862b9a3d"



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
    CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_DIR}/usr/include" \
    CPPFLAGS="${M3_CFLAGS} -I${STAGING_DIR}/usr/include" \
    NCURSES_LIBS="-L${STAGING_DIR}/lib -lncurses -ltinfow" \
    NCURSES_CFLAGS="-I${STAGING_DIR}/include/ncurses" \
    NCURSESW_LIBS="-L${STAGING_DIR}/lib -lncursesw -ltinfow" \
    NCURSESW_CFLAGS="-I${STAGING_DIR}/include/ncursesw" \
    ./configure \
        --target=${M3_TARGET} \
        --host=${M3_TARGET} \
        --disable-largefile \
        --disable-nls \
        --disable-rpath \
        --disable-browser \
        --disable-extra \
        --disable-libmagic \
        --disable-mouse \
        --disable-speller \
        --disable-glibtest \
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
