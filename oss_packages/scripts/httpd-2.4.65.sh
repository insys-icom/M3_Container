#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="httpd-2.4.65"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
#PKG_DOWNLOAD="https://dlcdn.apache.org/httpd/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="4f92861a50325c6d1046ebad5d814bff0d4169ada8cc265655f32b7f1ba4be1b"



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
        CROSS_COMPILE="${M3_CROSS_COMPILE}" \
        CFLAGS="${M3_CFLAGS} -I${PKG_BUILD_DIR}/include -I${STAGING_INCLUDE} -I${STAGING_INCLUDE}/apr-1" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -L${STAGING_LIB}/apr-util-1" \
        PCRE_CONFIG="${STAGING_DIR}/bin/pcre2-config" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="" \
        --enable-authn-anon \
        --enable-v4-mapped \
        --enable-authz-owner \
        --disable-imagemap \
        --disable-brotli \
        --disable-lua \
        --disable-dav \
        --disable-dav-fs \
        --disable-dav-lock \
        --enable-expires \
        --enable-headers \
        --enable-info \
        --enable-mime-magic \
        --enable-proxy \
        --enable-proxy-ajp \
        --enable-proxy-http \
        --enable-proxy-ftp \
        --enable-proxy-balancer \
        --enable-proxy-connect \
        --enable-suexec \
        --enable-rewrite \
        --enable-ssl \
        --disable-md \
        --enable-mods-shared=all \
        --enable-deflate \
        --enable-so \
        --enable-auth-digest \
        --with-ssl="${STAGING_DIR}" \
        --with-pcre="${STAGING_DIR}" \
        --with-libxml2="${STAGING_DIR}" \
        --with-jansson="${STAGING_DIR}" \
        --with-z="${STAGING_DIR}" \
        --disable-userdir \
        --enable-vhost-alias \
        --with-mpm=prefork \
        --with-apr="${STAGING_DIR}/bin/apr-1-config" \
        --with-apr-util="${STAGING_DIR}/bin/apu-1-config" \
        ap_cv_void_ptr_lt_long=no \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS}

    # create needed .h file
    cd server/
    gcc -Wall -O2 -DCROSS_COMPILE gen_test_char.c -s -o gen_test_char
    cd ..

    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
