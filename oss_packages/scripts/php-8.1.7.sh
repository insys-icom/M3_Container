#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="php-8.1.7"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
# https://www.php.net/downloads.php
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="f8be7dfca5c241e780f75f3f3ce83b76"



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
    copy_overlay
    ac_cv_lib_curl_curl_easy_perform=yes \
    ./configure \
        PKG_CONFIG=pkg-config \
        PKG_CONFIG_LIBDIR="${STAGING_LIB}/pkgconfig" \
        CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_INCLUDE}/apr-1" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        LIBS="-L${STAGING_LIB}" \
        LIBXML_CFLAGS="-I${STAGING_INCLUDE}/libxml2" \
        LIBXML_LIBS="-lxml2 -L${STAGING_LIB}" \
        OPENSSL_CFLAGS="-I${STAGING_INCLUDE}" \
        OPENSSL_LIBS="-lssl -lcrypto -L${STAGING_LIB}" \
        SQLITE_CFLAGS="-I${STAGING_INCLUDE}" \
        SQLITE_LIBS="-lsqlite3 -L${STAGING_LIB}" \
        ZLIB_CFLAGS="-I${STAGING_INCLUDE}" \
        ZLIB_LIBS="-lz -L${STAGING_LIB}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --build=x86_64-unknown-linux-gnu \
        --with-apxs2="${STAGING_DIR}"/bin/apxs \
        --with-config-file-path=/etc \
        --without-iconv \
        --disable-xmlreader \
        --disable-xmlwriter \
        --disable-phar \
        --disable-fileinfo \
        --enable-opcache=no \
        --disable-phpdbg \
        --enable-soap \
        --enable-sockets \
        --with-openssl \
        --with-zlib \
        --with-config-file-path=/etc/ \
        --prefix="${PKG_INSTALL_DIR}" \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}/install"
    cp bin/armv7a-hardfloat-linux-gnueabi-php "${STAGING_DIR}/bin/php"
    cp bin/armv7a-hardfloat-linux-gnueabi-php-cgi "${STAGING_DIR}/bin/php-cgi"
    cp bin/armv7a-hardfloat-linux-gnueabi-php-config "${STAGING_DIR}/bin/php-config"
    cp bin/armv7a-hardfloat-linux-gnueabi-phpize "${STAGING_DIR}/bin/phpize"

    cd "${PKG_BUILD_DIR}"
    cp libs/libphp.so "${STAGING_DIR}"/lib
    cp php.ini-production "${STAGING_DIR}"/etc/php.ini
}

uninstall_staging()
{
    rm "${STAGING_DIR}/bin/php"
    rm "${STAGING_DIR}/bin/php-cgi"
    rm "${STAGING_DIR}/bin/php-config"
    rm "${STAGING_DIR}/bin/phpize"
}

. ${HELPERSDIR}/call_functions.sh
