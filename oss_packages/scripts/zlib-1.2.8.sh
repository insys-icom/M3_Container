#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="http://zlib.net/zlib-1.2.8.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="44d667c142d7cda120332623eab69f40"

# name of directory after extracting the archive in working directory
PKG_DIR="zlib-1.2.8"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="zlib-1.2.8.tar.gz"

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
    export CHOST="${M3_TARGET}"
    ./configure --prefix=""
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} V=1 || exit_failure "failed to build ${PKG_DIR}"
    make prefix="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make prefix="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
