#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="nano-2.6.0"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="89051965a1de963190696348bc291b86"



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
    export CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_DIR}/usr/include"
    export CPPFLAGS="${M3_CFLAGS} -I${STAGING_DIR}/usr/include"
    export NCURSES_LIBS="-L${STAGING_DIR}/usr/lib -lncurses -ltinfow"
    export NCURSES_CFLAGS="-I${STAGING_DIR}/usr/include/ncurses"
    export NCURSESW_LIBS="-L${STAGING_DIR}/usr/lib -lncursesw -ltinfow"
    export NCURSESW_CFLAGS="-I${STAGING_DIR}/usr/include/ncursesw"

    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --disable-largefile --disable-nls --disable-rpath --disable-browser --disable-extra --disable-libmagic --disable-mouse --disable-speller --disable-glibtest --enable-utf8 --disable-help
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
    cp "${PKG_BUILD_DIR}/doc/nanorc.sample" "${STAGING_DIR}/etc/"
}

. ${HELPERSDIR}/call_functions.sh
