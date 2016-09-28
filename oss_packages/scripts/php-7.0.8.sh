#!/bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="http://de1.php.net/get/${PKG_ARCHIVE_FILE}/from/this/mirror"
PKG_DOWNLOAD="http://de1.php.net/get/php-7.0.8.tar.xz/from/this/mirror"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="c4438583c95d3ddf746929d7fcb61045"

# name of directory after extracting the archive in working directory
PKG_DIR="php-7.0.8"

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
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --build=x86_64-unknown-linux-gnu --without-iconv -disable-xmlreader --disable-xmlwriter --disable-phar --disable-fileinfo --enable-opcache=no --disable-phpdbg --enable-soap --enable-sockets --with-config-file-path=/etc/ --prefix="${PKG_INSTALL_DIR}"
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
