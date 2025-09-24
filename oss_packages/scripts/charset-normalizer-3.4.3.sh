#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="charset_normalizer-3.4.3"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

PYTHON_VERSION="python3.13"

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
