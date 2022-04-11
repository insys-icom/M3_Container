#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="lighttpd-1.4.59"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="http://download.lighttpd.net/lighttpd/releases-1.4.x/${PKG_ARCHIVE_FILE}"
# PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="a8838dac90fcddbcc05c0d1877bd8cdf"



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
        CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        PCRECONFIG="${STAGING_DIR}/bin/pcre-config" \
        XML_CFLAGS="-I${STAGING_INCLUDE}/libxml2" \
        XML_LIBS="-L${STAGING_LIB}" \
        SQLITE_CFLAGS="-I${STAGING_INCLUDE}" \
        SQLITE_LIBS="-L${STAGING_LIB}" \
        --target=${M3_TARGET} \
        --host=${M3_TARGET} \
        --with-openssl \
        --with-pam \
        --with-attr \
        --with-libxml \
        --with-zlib \
        --without-zstd \
        --without-brotli \
        --without-bzip2 \
        --without-lua \
        --with-pcre \
        --disable-lfs || exit_failure "failed to configure ${PKG_DIR}"
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
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
