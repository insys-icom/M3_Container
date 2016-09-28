#!/bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://swupdate.openvpn.org/community/releases/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://swupdate.openvpn.org/community/releases/openvpn-2.3.11.tar.xz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="fe17a25235d65e60af8986c6c78c4650"

# name of directory after extracting the archive in working directory
PKG_DIR="openvpn-2.3.11"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"


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
    export CFLAGS="${M3_CFLAGS}  -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS}  -L${STAGING_LIB}"
    export OPENSSL_SSL_LIBS="-lssl -L${STAGING_LIB}"
    export OPENSSL_SSL_CFLAGS="-I${STAGING_INCLUDE}"
    export OPENSSL_CRYPTO_CFLAGS="-I${STAGING_INCLUDE}"
    export OPENSSL_CRYPTO_LIBS="-lcrypto -L${STAGING_LIB}"
    export IPROUTE=/sbin/iproute
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix="" --disable-plugin-auth-pam --disable-plugins --disable-debug --enable-password-save --enable-iproute2 --enable-small
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
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
