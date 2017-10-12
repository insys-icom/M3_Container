#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="irrlicht-1.8.4"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.zip"

# download link for the sources to be stored in dl directory
# http://downloads.sourceforge.net/irrlicht/irrlicht-1.8.4.zip
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="9401cfff801395010b0912211f3cbb4f"



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
    true
}

install_staging()
{
    true
}

. ${HELPERSDIR}/call_functions.sh
