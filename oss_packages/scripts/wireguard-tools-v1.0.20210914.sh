#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="wireguard-tools-v1.0.20210914"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://git.zx2c4.com/wireguard-tools"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="6b314b2ef1ef1622157fd4ad8aa90b1a94a7d0708cfa6ef60208110d8978a142"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    true
}

compile()
{
    cd "${PKG_BUILD_DIR}/src"
    export WITH_BASHCOMPLETION=no
    export WITH_WGQUICK default=no
    export WITH_SYSTEMDUNITS=no
    export DEBUG=no
    make CC="${M3_TARGET}-gcc" ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    mkdir -p "${PKG_BUILD_DIR}/usr/bin"
    cp install/usr/bin/wg "${STAGING_DIR}/usr/bin" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
