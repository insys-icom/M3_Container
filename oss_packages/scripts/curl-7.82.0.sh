#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="curl-7.82.0"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://curl.se/download/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="877ca5b5ea2199d37ba357412e7d74be"



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
    ./configure \
        PKG_CONFIG=pkg-config \
        PKG_CONFIG_LIBDIR="${STAGING_LIB}/pkgconfig" \
        CFLAGS="${M3_CFLAGS}" \
        LDFLAGS="${M3_LDFLAGS}" \
        CPPFLAGS="-I${STAGING_INCLUDE}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --with-ssl="${STAGING_DIR}" \
        --with-zlib="${STAGING_DIR}" \
        --with-libssh2="${STAGING_DIR}" \
        --prefix="" \
        --enable-shared \
        --enable-http \
        --enable-ftp \
        --enable-file \
        --disable-ldap \
        --disable-ldaps \
        --disable-rtsp \
        --disable-proxy \
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
        --disable-ares \
        --without-gnutls \
        --without-polarssl \
        --without-cyassl \
        --without-axtls \
        --without-libidn2 \
        --without-winidn \
        --without-libgsasl \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} \
         V=1 \
         CFLAGS="${M3_CFLAGS} -lssl -lcrypto -lnghttp2 -lssh2" || exit_failure "failed to build ${PKG_DIR}"
         make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
