#! /bin/sh

SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_DIR="curl-7.47.1"
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"
PKG_CHECKSUM="9ea3123449439bbd960cd25cf98796fb"

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    export CFLAGS="${M3_CFLAGS}"
    export LDFLAGS="${M3_LDFLAGS}"
    # export PKG_CONFIG_LIBDIR="${STAGING_LIB}/pkgconfig"
    # dont use the gentoo wrapper, it will only word on packages installed by cross-emerge
    # export PKG_CONFIG=pkg-config
    # the wohle pkg-config stuff cant't be used here, because configure will overwrite all possible variables
    # --with-ssl= will be used as PKG_CONFIG_LIBDIR
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --enable-shared --prefix="" \
    --enable-http --enable-ftp --enable-file --disable-ldap --disable-ldaps --enable-rtsp \
    --enable-proxy --disable-dict --enable-telnet --enable-tftp --disable-gopher --with-nghttp2 \
    --enable-pop3 --enable-imap --enable-smtp \
    --disable-libcurl-option --enable-libgcc --enable-ipv6 --disable-versioned-symbols \
    --disable-threaded-resolver --disable-verbose --disable-sspi --enable-crypto-auth \
    --disable-ntlm-wb --enable-tls-srp --enable-cookies \
    --with-ssl="${STAGING_DIR}" --without-gnutls --without-polarssl --without-cyassl --without-axtls \
    --without-libmetalink --without-libssh2 --without-winidn
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} V=1 curl_LDFLAGS="-lssl -lcrypto " CFLAGS="${M3_CFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
