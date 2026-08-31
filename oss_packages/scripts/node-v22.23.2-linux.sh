#!/bin/sh
SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. ${TOPDIR}/scripts/common_settings.sh

VERSION="22.23.2"

# name of directory after extracting the archive in working directory
[ "${ARCH}" == "armv7" ]   && PKG_DIR="node-v${VERSION}-linux-armv7l"
[ "${ARCH}" == "aarch64" ] && PKG_DIR="node-v${VERSION}-linux-arm64"
[ "${ARCH}" == "amd64" ]   && PKG_DIR="node-v${VERSION}-linux-x64"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://nodejs.org/dist/v${VERSION}/${PKG_ARCHIVE_FILE}"


# md5 checksum of archive in dl directory
[ "${ARCH}" == "armv7" ]   && PKG_CHECKSUM="ef8f26a3de19acd8c23548e6c3cfc2052610b0e67abb5fd64dbd92c8b1c1245b"
[ "${ARCH}" == "aarch64" ] && PKG_CHECKSUM="fff4078c5def658577f92c88db7db3bc0072924bfb93fe52c1e744a54e94abb8"
[ "${ARCH}" == "amd64" ]   && PKG_CHECKSUM="d60acfe00a2932254bb0ad20e01b0d74397a0875595de719654b214f4b03f307"

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
