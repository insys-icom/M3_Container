#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="libffi-3.4.6"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://github.com/libffi/libffi/releases/download/v${PKG_DIR##*-}/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="b0dea9df23c863a7a50e825440f3ebffabd65df1497108e5d437747843895a4e"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}"/scripts/common_settings.sh
. "${HELPERSDIR}"/functions.sh
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    ./configure \
        CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="" \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}/install"
    cp -r ./lib/libffi.so* "${STAGING_LIB}"
    cp -r ./lib64/libffi.so* "${STAGING_LIB}"
    cp -r ./include/* "${STAGING_INCLUDE}"
}

uninstall_staging()
{
    cd "${PKG_BUILD_DIR}/install"
    rm "${STAGING_LIB}"/libffi*
    rm "${STAGING_INCLUDE}"/ffi.h
    rm "${STAGING_INCLUDE}"/ffitarget.h
}

. ${HELPERSDIR}/call_functions.sh
