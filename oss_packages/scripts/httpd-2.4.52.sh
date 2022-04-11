#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="httpd-2.4.52"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://artfiles.org/apache.org/httpd/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
#PKG_CHECKSUM="ff86e0e57e3172c21a3dc495909be002"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"



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
    # apr-util depends on apr and apr-util, compile it first
    APR_VERSION="apr-1.7.0"
    [ ! -f "${SCRIPTSDIR}/${APR_VERSION}.sh" ] && exit_failure "compile ${SCRIPTSDIR}/${APR_VERSION} first!"
    APR_WORKING="${PKG_BUILD_DIR}/../${APR_VERSION}/"
    [ ! -d "${APR_WORKING}" ] && exit_failure "compile ${APR_VERSION} first!"

    APRUTIL_VERSION="apr-util-1.6.1"
    [ ! -f "${SCRIPTSDIR}/${APRUTIL_VERSION}.sh" ] && exit_failure "compile ${SCRIPTSDIR}/${APRUTIL_VERSION} first!"
    APRUTIL_WORKING="${PKG_BUILD_DIR}/../${APRUTIL_VERSION}/"
    [ ! -d "${APR_WORKING}" ] && exit_failure "compile ${APRUTIL_VERSION} first!"

    cd "${PKG_BUILD_DIR}"
    ./configure \
        CROSS_COMPILE="${M3_CROSS_COMPILE}" \
        CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="" \
        --enable-authn-anon \
        --enable-v4-mapped \
        --enable-authz-owner \
        --enable-auth-digest \
        --disable-imagemap \
        --disable-brotli \
        --disable-lua \
        --enable-dav \
        --enable-dav-fs \
        --enable-dav-lock \
        --enable-deflate \
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
        --enable-so \
        --enable-ssl \
        --with-z="${STAGING_DIR}" \
        --with-ssl="${STAGING_DIR}" \
        --with-pcre="${STAGING_DIR}" \
        --with-libxml2="${STAGING_DIR}" \
        --with-jansson="${STAGING_DIR}" \
        --disable-userdir \
        --enable-vhost-alias \
        --with-mpm=prefork \
        --enable-mods-shared=all \
        --with-apr="${APR_WORKING}" \
        --with-apr-util="${APRUTIL_WORKING}" \
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
