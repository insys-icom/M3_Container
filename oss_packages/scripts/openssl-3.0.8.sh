#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="openssl-3.0.8"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
#PKG_DOWNLOAD="https://www.openssl.org/source/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="61e017cf4fea1b599048f621f1490fbd"



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
    cd "${PKG_BUILD_DIR}"

    if [ "${M3_TARGET}" = "x86_64-pc-linux-gnu" ] ; then
        OPENSSL_CONFIGURE_TARGET="linux-x86_64"
    else
        OPENSSL_CONFIGURE_TARGET="linux-armv4"
    fi

    CFLAGS="${M3_CFLAGS}" \
    LDFLAGS="${M3_LDFLAGS}" \
    AR="${AR}" \
    RANLIB="gcc-ranlib" \
    NM="${NM}" \
    ./Configure ${OPENSSL_CONFIGURE_TARGET} \
        --cross-compile-prefix="${M3_CROSS_COMPILE}" \
        --prefix="/" \
        --openssldir="/ssl" \
        no-camellia \
        no-seed \
        no-ssl \
        no-ssl3 \
        no-acvp-tests \
        no-buildtest-c++ \
        no-external-tests \
        no-tests \
        no-unit-test \
        shared

    if [ $? -ne 0 ]; then
        exit_failure "failed to configure ${PKG_DIR}"
    fi
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make build_sw ${M3_MAKEFLAGS}  \
         AR="${AR}" \
         NM="${NM}" \
         RANLIB="gcc-ranlib" \
         V=1 \
         || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install_sw || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
