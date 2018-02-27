#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="php-7.1.14"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
# http://de2.php.net/get/php-7.1.14.tar.xz/from/this/mirror
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="6c00d9c11db8d05bb86d1244ca9098d0"



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
    CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        ./configure \
            --target=${M3_TARGET} \
            --host=${M3_TARGET} \
            --build=x86_64-unknown-linux-gnu \
            --without-iconv \
            --disable-xmlreader \
            --disable-xmlwriter \
            --disable-phar \
            --disable-fileinfo \
            --enable-opcache=no \
            --disable-phpdbg \
            --enable-soap \
            --enable-sockets \
            --with-config-file-path=/etc/ \
            --prefix="${PKG_INSTALL_DIR}"  || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
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
}

uninstall_staging()
{
    rm "${STAGING_DIR}/bin/php"
    rm "${STAGING_DIR}/bin/php-cgi"
    rm "${STAGING_DIR}/bin/php-config"
    rm "${STAGING_DIR}/bin/phpize"
}

. ${HELPERSDIR}/call_functions.sh
