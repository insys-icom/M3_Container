#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="get-pip.py"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}"

# download link for the sources to be stored in dl directory
# https://bootstrap.pypa.io/get-pip.py version 9.0.1
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="a100df19c686c334a9401942e224a247"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

unpack()
{
    # this is a special case: the downloaded file is not an archive. It is a python script that contains an base85 encoded zip. It just must be copied to the rootfs_staging
    true
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
    cp "${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}" "${STAGING_DIR}/bin"
    chmod 755 "${STAGING_DIR}/bin/${PKG_ARCHIVE_FILE}"
    echo -en "\nTo install pip execute \"/bin/get-pip.sh\" after logging into the container as root.\n"
    echo -en "The container must have internet connection. The script will install pip, wheel and setuptools.\n"
}

uninstall_staging()
{
    rm "${STAGING_DIR}/bin/${PKG_ARCHIVE_FILE}"
}

. ${HELPERSDIR}/call_functions.sh
