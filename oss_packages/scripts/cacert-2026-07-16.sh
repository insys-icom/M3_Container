#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="cacert-2026-07-16.pem"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://curl.se/ca/${PKG_DIR}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="3ff344e30b9b1ed2971044eabb438a08f2e2245ddb5f8ab1a3ad8b63ab4eaf91"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

unpack()
{
    ! [ -e "${PKG_BUILD_DIR}" ] && mkdir -p "${PKG_BUILD_DIR}"
    ! [ -e "${TARGET_DIR}" ] && mkdir -p "${TARGET_DIR}"
    cp "${PKG_ARCHIVE}" "${PKG_BUILD_DIR}"
}

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
    mkdir -p "${STAGING_DIR}/usr/share"
    cp "${PKG_BUILD_DIR}/${PKG_DIR}" "${STAGING_DIR}/usr/share/cacert.pem" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

uninstall_staging()
{
    rm -vf "${STAGING_DIR}/usr/share/cacert.pem"
}

. ${HELPERSDIR}/call_functions.sh
