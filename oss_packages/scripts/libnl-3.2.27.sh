#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="libnl-3.2.27"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# https://github.com/thom311/libnl/releases/download/libnl3_2_27/libnl-3.2.27.tar.gz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="cec19f941b79a38d9eb92dbc171d6dbd"



configure()
{
    cd "${PKG_BUILD_DIR}"
    export CFLAGS="${M3_CFLAGS}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --enable-shared --enable-static --prefix="" --disable-debug
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
