#!/bin/sh

SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_DIR="gnutls-3.6.0"
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"
PKG_DOWNLOAD="https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/${PKG_ARCHIVE_FILE}"
#PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"
PKG_CHECKSUM="296f8d61333851b9326bd18484e6135e"

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
   ./configure  CC="${M3_CROSS_COMPILE}gcc" \
                CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_INCLUDE}/nettle" \
                LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -lnettle -lhogweed -lgmp" \
                PKG_CONFIG=pkg-config \
                PKG_CONFIG_PATH="${STAGING_LIB}/pkgconfig" \
                --target=${M3_TARGET} \
                --host=${M3_TARGET} \
                --prefix="" \
                --enable-shared \
                --disable-static \
                --with-included-unistring \
                --disable-code-coverage \
                --disable-maintainer-mode \
                --disable-manpages \
                --disable-cxx \
                --disable-tests \
                --disable-gtk-doc-html \
                --disable-full-test-suite \
                --without-p11-kit \
                --disable-guile \
                --without-tpm \
                --disable-libdane \
                --without-idn \
                --with-included-libtasn1 \
                --disable-ssl2-support \
                --disable-ssl3-support \
                --without-zlib \
                --enable-local-libopts
#                 --with-nettle-mini

    if [ $? -ne 0 ]; then
        echo "############################################################"
        echo "This needs the following packages, so build these first!"
        echo "  nettle"
        echo "############################################################"
        exit_failure "failed to configure ${PKG_DIR}"
    fi
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    # we use nettle-mini which includes mini-gmp so fake the existance of gmp.h
#    touch lib/nettle/int/gmp.h
    make V=s ${M3_MAKEFLAGS}
    if [ $? -ne 0 ]; then
        echo "############################################################"
        echo "This needs the following packages, so build these first!"
        echo "  nettle"
        echo "############################################################"
        exit_failure "failed to build ${PKG_DIR}"
    else
        make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
    fi
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
    # Delete *.la files from this library in staging directory, otherwise libmicrohttpd looks under /lib for this library
    find "${STAGING_LIB}" -type f -iname "libgnutls*.la" | xargs rm -vf
}

. ${HELPERSDIR}/call_functions.sh
