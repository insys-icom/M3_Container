#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="http://downloads.sourceforge.net/project/pcre/pcre/8.38/pcre-8.38.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fpcre%2F&ts=1465978062&use_mirror=netassist"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="00aabbfe56d5a48b270f999b508c5ad2"

# name of directory after extracting the archive in working directory
PKG_DIR="pcre-8.38"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

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
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --disable-pcregrep-jit --enable-shared=no --enable-utf --disable-cpp --prefix=""
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
