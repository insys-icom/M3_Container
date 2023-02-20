#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="pymodbus-3.1.3"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://files.pythonhosted.org/packages/67/96/36651fd37cd6adae9ed5885e9042d23f1320c3e513e09593248aee503b1e/pymodbus-3.1.3.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="7187cac9be812ee80d614a1496424d77"



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
    mkdir -p "${STAGING_DIR}/lib/python3.11/site-packages"
    cp -a "${PKG_BUILD_DIR}/"* "${STAGING_DIR}/lib/python3.11/site-packages/"
}

uninstall_staging()
{
    rm -rf "${STAGING_DIR}/lib/python3.11/site-packages/pymodbus"*
}

. ${HELPERSDIR}/call_functions.sh
