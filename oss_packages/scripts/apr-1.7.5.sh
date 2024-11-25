#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="apr-1.7.5"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
#PKG_DOWNLOAD="https://artfiles.org/apache.org/apr/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="3375fa365d67bcf945e52b52cba07abea57ef530f40b281ffbe977a9251361db"



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
        CFLAGS="${M3_CFLAGS} -fcommon -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="/" \
        --disable-lfs \
        --enable-sysv-shm \
        --enable-threads \
        --disable-fast-install \
        --with-devrandom=/dev/random \
        ac_cv_file__dev_zero=yes \
        ac_cv_func_setpgrp_void=yes \
        apr_cv_tcp_nodelay_with_cork=yes \
        apr_cv_process_shared_works=no \
        ac_cv_sizeof_struct_iovec=1 \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"

    cp "${PKG_BUILD_DIR}/build/apr_rules.mk" "${STAGING_DIR}/build-1/"

    # fix path to libuuid and libcrypt in libtool file
    sed -i "s|/lib/libuuid.la|${STAGING_LIB}/libuuid.la|" "${STAGING_LIB}/libapr-1.la"
    sed -i "s|/lib/libcrypt.la|${STAGING_LIB}/libcrypt.la|" "${STAGING_LIB}/libapr-1.la"
}

. ${HELPERSDIR}/call_functions.sh
