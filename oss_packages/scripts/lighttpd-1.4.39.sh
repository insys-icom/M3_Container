#!/bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="http://download.lighttpd.net/lighttpd/releases-1.4.x/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="63c7563be1c7a7a9819a51f07f1af8b2"

# name of directory after extracting the archive in working directory
PKG_DIR="lighttpd-1.4.39"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"


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
    export CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -lpcre"
    export PCRECONFIG="${STAGING}/bin/pcre-config"

    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --with-openssl --with-zlib --without-bzip2 --with-webdav-props --with-webdav-locks --without-lua --with-pcre --with-memcache --disable-lfs --with-gdbm
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
