#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="python_modules-2022-03-31"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="166ab6f99b89f9ead1bf5ffe88a36a8a"



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
    # there is nothing to download, everything is in the repo in oss_packages/src/python_modules
    true
}

compile()
{
    copy_overlay
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    mkdir -p "${STAGING_DIR}/lib/python3.11/site-packages"
    cp -a "${PKG_BUILD_DIR}/"* "${STAGING_DIR}/lib/python3.11/site-packages/"
}

uninstall_staging()
{
    rm -rf "${STAGING_DIR}/lib/python3.11/site-packages"
}

. ${HELPERSDIR}/call_functions.sh
