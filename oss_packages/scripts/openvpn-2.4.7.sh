#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="openvpn-2.4.7"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://swupdate.openvpn.org/community/releases/{PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="4ad8a008e1e7f261b3aa0024e79e7fb7"



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
    ./configure CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
              LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
              IPROUTE="/sbin/iproute" \
              OPENSSL_SSL_LIBS="-lssl -L${STAGING_LIB}" \
              OPENSSL_SSL_CFLAGS="-I${STAGING_INCLUDE}" \
              OPENSSL_CRYPTO_CFLAGS="-I${STAGING_INCLUDE}" \
              OPENSSL_CRYPTO_LIBS="-lcrypto -L${STAGING_LIB}" \
              --target=${M3_TARGET} \
              --host=${M3_TARGET} \
              --prefix="" \
              --disable-plugin-auth-pam \
              --disable-plugins \
              --disable-debug \
              --enable-iproute2 \
              --enable-small || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
