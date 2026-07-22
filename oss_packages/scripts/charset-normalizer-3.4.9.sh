#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="charset_normalizer-3.4.9"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://github.com/jawah/charset_normalizer/releases/download/${PKG_DIR##*-}/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"



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
    cd "${PKG_BUILD_DIR}"
    mkdir -p "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/site-packages"
    cp -a "${PKG_BUILD_DIR}/src/charset_normalizer" "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/site-packages/"
}

uninstall_staging()
{
    rm -rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/site-packages/charset_normalizer"
}

. ${HELPERSDIR}/call_functions.sh
