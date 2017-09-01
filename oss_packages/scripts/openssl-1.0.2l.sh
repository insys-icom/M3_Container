#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="openssl-1.0.2l"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# https://www.openssl.org/source/openssl-1.0.2l.tar.gz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="f85123cd390e864dfbe517e7616e6566"



SCRIPTSDIR="$(dirname $0)"
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR="$(realpath ${SCRIPTSDIR}/../..)"
. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    export CFLAGS_APPEND="${M3_CFLAGS} ${M3_LDFLAGS}"

    ./Configure linux-armv4 -no-err -no-camellia -no-seed -no-hw -no-ssl2 -no-ssl3 --prefix="${STAGING_DIR}" shared
    sed 's/ -O3 / $(CFLAGS_APPEND) /' -i Makefile
    make depend
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    # ossl buildsys sucks, do not make parallel builds
    make AR="${AR} r" RANLIB="${RANLIB}" NM="${NM}" V=1 || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" AR="${AR} r" RANLIB="${RANLIB}" NM="${NM}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" AR="${AR} r" RANLIB="${RANLIB}" NM="${NM}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
