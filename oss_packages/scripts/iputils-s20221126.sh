#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="iputils-20221126"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# PKG_DOWNLOAD="https://github.com/iputils/iputils/archive/${PKG_ARCHIVE_FILE##*-}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="f2d296dc69135dcd2e95e3dd740fce94"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    ./configure
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make clean
    # add -fcommon to compile with modern gcc
    make "CC=${M3_CROSS_COMPILE}gcc" \
         CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
         LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
         USE_IDN=no \
         USE_NETTLE=no \
         USE_CRYPTO=no \
         USE_CAP=no \
         ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    mkdir -p "${STAGING_DIR}"/usr/net_tools || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
    cp -v arping clockdiff ping rarpd rdisc tracepath traceroute6 "${STAGING_DIR}/usr/net_tools" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

uninstall_staging()
{
    rm -rf "${STAGING_DIR}"/usr/net_tools
}

. ${HELPERSDIR}/call_functions.sh
