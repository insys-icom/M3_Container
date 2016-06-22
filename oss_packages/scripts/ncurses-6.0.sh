#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="http://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="ee13d052e1ead260d7c28071f46eefb1"

# name of directory after extracting the archive in working directory
PKG_DIR="ncurses-6.0"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

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
    export CFLAGS="${M3_CFLAGS}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --with-termlib --enable-static --disable-shared --prefix="" --without-cxx --without-ada --without-manpages --without-progs --without-tests --disable-big-core --disable-home-terminfo --without-develop 
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
