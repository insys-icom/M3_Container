#!/bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="ftp://ftp.gnu.org/gnu/gdbm/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="ftp://ftp.gnu.org/gnu/gdbm/gdbm-1.12.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="9ce96ff4c99e74295ea19040931c8fb9"

# name of directory after extracting the archive in working directory
PKG_DIR="gdbm-1.12"

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
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix="" --disable-nls --disable-largefile
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
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
