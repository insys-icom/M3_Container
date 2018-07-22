#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="libffi-3.2.1"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="83b89587607e3eb65c70d361f13bab43"



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
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix=""
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
    cd "${PKG_BUILD_DIR}/install"
    cp -r ./lib/libffi.so* ${STAGING_LIB}
    cp -r ./lib/${PKG_DIR}/include/* ${STAGING_INCLUDE}
}

uninstall_staging()
{
    cd "${PKG_BUILD_DIR}/install"
    rm ${STAGING_LIB}/libffi*
    rm ${STAGING_INCLUDE}/ffi.h
    rm ${STAGING_INCLUDE}/ffitarget.h
}

. ${HELPERSDIR}/call_functions.sh
