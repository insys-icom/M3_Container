#!/bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="ftp://xmlsoft.org/libxml2/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="ae249165c173b1ff386ee8ad676815f5"

# name of directory after extracting the archive in working directory
PKG_DIR="libxml2-2.9.4"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"


SCRIPTSDIR="$(dirname $0)"
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR="$(realpath ${SCRIPTSDIR}/../..)"

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
    export LDFLAGS="${M3_LDFLAGS}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix="" --without-python #--with-minimum
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
