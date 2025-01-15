#!/bin/sh
SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. ${TOPDIR}/scripts/common_settings.sh

# name of directory after extracting the archive in working directory
[ "${ARCH}" == "armv7" ]   && PKG_DIR="node-v22.13.0-linux-armv7l"
[ "${ARCH}" == "aarch64" ] && PKG_DIR="node-v22.13.0-linux-arm64"
[ "${ARCH}" == "amd64" ]   && PKG_DIR="node-v22.13.0-linux-x64"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://nodejs.org/dist/v22.13.0/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
[ "${ARCH}" == "armv7" ]   && PKG_CHECKSUM="308687472523deee7abacc342e753e9b402ff4b178025374668039996b5c9699"
[ "${ARCH}" == "aarch64" ] && PKG_CHECKSUM="5de54a12983d0de6ba23597d4d0194e64933e26b0f04a469db3be9c3e18b6b2b"
[ "${ARCH}" == "amd64" ]   && PKG_CHECKSUM="3ff0d57063c33313d73d0bdcebc4c778ad6be948234584694a042c6fe57164f6"

. ${HELPERSDIR}/functions.sh
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
    cp -a bin/node "${STAGING_DIR}/bin"
    cp -a lib/* "${STAGING_LIB}"
}

uninstall_staging()
{
    cd "${STAGING_DIR}"
    rm -Rf bin/node
    rm -Rf "${STAGING_LIB}/node_modules}"
}

. ${HELPERSDIR}/call_functions.sh
