#!/bin/sh
SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. ${TOPDIR}/scripts/common_settings.sh

# name of directory after extracting the archive in working directory
[ "${ARCH}" == "armv7" ]   && PKG_DIR="node-v22.21.1-linux-armv7l"
[ "${ARCH}" == "aarch64" ] && PKG_DIR="node-v22.21.1-linux-arm64"
[ "${ARCH}" == "amd64" ]   && PKG_DIR="node-v22.21.1-linux-x64"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://nodejs.org/dist/v22.13.0/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
[ "${ARCH}" == "armv7" ]   && PKG_CHECKSUM="69faec17156bc240a7e7590bcfb236194e4c09412387ac94318e8b30f72155e0"
[ "${ARCH}" == "aarch64" ] && PKG_CHECKSUM="e660365729b434af422bcd2e8e14228637ecf24a1de2cd7c916ad48f2a0521e1"
[ "${ARCH}" == "amd64" ]   && PKG_CHECKSUM="680d3f30b24a7ff24b98db5e96f294c0070f8f9078df658da1bce1b9c9873c88"

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
