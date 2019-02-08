#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="curl-7.64.0"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://curl.haxx.se/download/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="d0bcc586873cfef08b4b9594e5395a33"



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
    ./configure PKG_CONFIG=pkg-config \
                PKG_CONFIG_LIBDIR="${STAGING_LIB}/pkgconfig" \
                CFLAGS="${M3_CFLAGS}" \
                LDFLAGS="${M3_LDFLAGS}" \
                CPPFLAGS="-I${STAGING_INCLUDE}" \
                --target="${M3_TARGET}" \
                --host="${M3_TARGET}" \
                --with-nghttp2="${STAGING_DIR}" \
                --with-ssl="${STAGING_DIR}" \
                --with-zlib="${STAGING_DIR}" \
                --with-ca-bundle="/usr/share/cacert.pem" \
                --prefix="" \
                --enable-shared \
                --enable-http \
                --enable-ftp \
                --enable-file \
                --disable-ldap \
                --disable-ldaps \
                --enable-rtsp \
                --enable-proxy \
                --disable-dict \
                --enable-telnet \
                --enable-tftp \
                --disable-gopher \
                --enable-pop3 \
                --enable-imap \
                --enable-smtp \
                --disable-libcurl-option \
                --enable-libgcc \
                --enable-ipv6 \
                --disable-versioned-symbols \
                --disable-threaded-resolver \
                --disable-verbose \
                --disable-sspi \
                --enable-crypto-auth \
                --disable-ntlm-wb \
                --enable-tls-srp \
                --enable-cookies \
                --without-gnutls \
                --without-polarssl \
                --without-cyassl \
                --without-axtls \
                --without-libmetalink \
                --without-libssh2 \
                --without-winidn || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} \
         V=1 \
         curl_LDFLAGS="-lssl -lcrypto -lnghttp2" \
         CFLAGS="${M3_CFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
         make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
