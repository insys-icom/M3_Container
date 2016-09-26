#!/bin/sh

SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_DIR="readline-6.3"
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"
PKG_DOWNLOAD="ftp://ftp.cwru.edu/pub/bash/${PKG_ARCHIVE_FILE}"
PKG_CHECKSUM="33c8fb279e981274f485fd91da77e94a"

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    export CFLAGS="${M3_CFLAGS}"
    export bash_cv_func_sigsetjmp='present'
    export bash_cv_func_ctype_nonascii='yes'
    export bash_cv_wcwidth_broken='no' 
        
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --disable-largefile --enable-multibyte --with-curses --enable-shared --enable-static --prefix=""
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
