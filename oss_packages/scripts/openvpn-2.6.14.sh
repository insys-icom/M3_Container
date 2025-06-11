#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="openvpn-2.6.13"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://swupdate.openvpn.org/community/releases/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="1af10b86922bd7c99827cc0f151dfe9684337b8e5ebdb397539172841ac24a6a"



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
    ac_cv_func_SSL_CTX_new=yes \
    ac_cv_func_EVP_aes_256_gcm=yes \
    ac_cv_lib_lz4_LZ4_compress_default=yes \
    ac_cv_lib_lz4_LZ4_decompress_safe=yes \
        ./configure CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
            LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
            IPROUTE="/sbin/iproute" \
            OPENSSL_CFLAGS="-I${STAGING_INCLUDE}" \
            OPENSSL_LIBS="-lssl -lcrypto -L${STAGING_LIB}" \
            LIBCAPNG_CFLAGS="-I${STAGING_INCLUDE}" \
            LIBCAPNG_LIBS="-lcap-ng -L${STAGING_LIB}" \
            LZ4_CFLAGS="-I${STAGING_INCLUDE}" \
            LZ4_LIBS="-llz4 -L${STAGING_LIB}" \
            --target="${M3_TARGET}" \
            --host="${M3_TARGET}" \
            --prefix="" \
            --disable-plugin-auth-pam \
            --disable-debug \
            --disable-unit-tests \
            --disable-dco \
            --disable-lzo \
            || exit_failure "failed to configure ${PKG_DIR}"
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
    cp -rv ${PKG_INSTALL_DIR}/* ${STAGING_DIR} || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
