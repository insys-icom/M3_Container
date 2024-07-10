#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="apr-util-1.6.3"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
#PKG_DOWNLOAD="https://mirror.checkdomain.de/apache/apr/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="2b74d8932703826862ca305b094eef2983c27b39d5c9414442e9976a9acf1983"



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
    cp "${STAGING_DIR}/build-1/apr_rules.mk" "${PKG_BUILD_DIR}/build/rules.mk" ||
        exit_failure "failed to configure ${PKG_DIR} because of missing apr_rules.mk"

    cd "${PKG_BUILD_DIR}"
    ./configure \
        CROSS_COMPILE="${M3_CROSS_COMPILE}" \
        CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_DIR} -L${STAGING_LIB}" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="" \
        --build=x86_64-pc-linux-gnu \
        --with-apr="${STAGING_DIR}/bin/apr-1-config" \
        --with-expat="${STAGING_DIR}" \
        --with-sqlite3="${STAGING_INCLUDE}" \
        --with-openssl="${STAGING_INCLUDE}" \
        --with-crypto \
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
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"

    # fix path to libuuid, libexpat and libapr in libtool file
    sed -i "s| /lib/libuuid.la| /home/user/Container/M3_Container/rootfs_staging/${ARCH}/lib/libuuid.la|" "${STAGING_LIB}/libaprutil-1.la"
    sed -i "s| /lib/libexpat.la| /home/user/Container/M3_Container/rootfs_staging/${ARCH}/lib/libexpat.la|" "${STAGING_LIB}/libaprutil-1.la"
    sed -i "s| //lib/libapr-1.la| /home/user/Container/M3_Container/rootfs_staging/${ARCH}/lib/libapr-1.la|" "${STAGING_LIB}/libaprutil-1.la"
}

. ${HELPERSDIR}/call_functions.sh
