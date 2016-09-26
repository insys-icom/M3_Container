#!/bin/sh

SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_DIR="bftpd-4.4"
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"
PKG_DOWNLOAD="http://downloads.sourceforge.net/project/bftpd/bftpd/${PKG_DIR}/${PKG_ARCHIVE_FILE}?r=&ts=1474881057&use_mirror=netcologne"
PKG_CHECKSUM="dbd6740895e04f083b393b1167a11936"

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"    
    export CPPFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"    
    export CC="${M3_CROSS_COMPILE}gcc"    
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --enable-pam --enable-libz 
}

compile()
{
    copy_overlay    
    cd "${PKG_BUILD_DIR}"
    export CPPFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"    
    export CC="${M3_CROSS_COMPILE}gcc"
    make ${M3_MAKEFLAGS} LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp bftpd.conf "${STAGING_DIR}/etc"
    cp bftpd "${STAGING_DIR}/bin"    
}

. ${HELPERSDIR}/call_functions.sh
