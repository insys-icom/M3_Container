#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="paho.mqtt.python-2.1.0"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://github.com/eclipse-paho/paho.mqtt.python/archive/refs/tags/v${PKG_ARCHIVE_FILE#*-}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="3602ce9d1ada58b063f2052ff013ff8cdd06d66cef918d5f6d048b6f68ccf049"



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
    cp -a "${PKG_BUILD_DIR}/src/"* "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/site-packages/"
}

uninstall_staging()
{
    rm -rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/site-packages/paho/mqtt"
}

. ${HELPERSDIR}/call_functions.sh
