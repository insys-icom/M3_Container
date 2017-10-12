#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="iputils-s20151218"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

# download link for the sources to be stored in dl directory
# http://www.skbuff.net/iputils/iputils-s20151218.tar.bz2
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="8aaa7395f27dff9f57ae016d4bc753ce"



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
    sed -i "s@CC=gcc@CC="$M3_CROSS_COMPILE"gcc@" "${PKG_BUILD_DIR}/Makefile"
    sed -i "s@USE_GCRYPT=yes@USE_GCRYPT=no@" "${PKG_BUILD_DIR}/Makefile"
    sed -i "s@LIBC_INCLUDE=/usr/include@LIBC_INCLUDE=$STAGING_INCLUDE@" "${PKG_BUILD_DIR}/Makefile"
    sed -i "s@CCOPTOPT=-O3@CCOPTOPT=-O2 -I"$STAGING_INCLUDE"@" "${PKG_BUILD_DIR}/Makefile"
}

compile()
{
    export CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    cd "${PKG_BUILD_DIR}"
    make clean
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    ! [ -e "${STAGING_DIR}"/usr/net_tools ] && mkdir "${STAGING_DIR}"/usr/net_tools
    cp arping clockdiff ping ping6 rarpd rdisc tracepath tracepath6 traceroute6 "${STAGING_DIR}/usr/net_tools"
}

uninstall_staging()
{
    rm -rf "${STAGING_DIR}"/usr/net_tools
}

. ${HELPERSDIR}/call_functions.sh
