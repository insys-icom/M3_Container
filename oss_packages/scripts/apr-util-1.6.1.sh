#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="apr-util-1.6.1"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://mirror.checkdomain.de/apache//apr/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="bd502b9a8670a8012c4d90c31a84955f"



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
    # apr-util depends on apr, compile it first
    APR_VERSION="apr-1.7.0"
    [ ! -f "${SCRIPTSDIR}/${APR_VERSION}.sh" ] && exit_failure "compile ${SCRIPTSDIR}/${APR_VERSION} first!"
    APR_WORKING="${PKG_BUILD_DIR}/../${APR_VERSION}/"
    [ ! -d "${APR_WORKING}" ] && exit_failure "compile ${APR_VERSION} first!"

    cd "${PKG_BUILD_DIR}"
    ./configure \
        CROSS_COMPILE="${M3_CROSS_COMPILE}" \
        CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -Wl,-rpath,${STAGING_LIB},--enable-new-dtags" \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --build=x86_64-pc-linux-gnu \
        --with-apr="${APR_WORKING}" \
        --with-expat="${STAGING_DIR}" \
        --with-sqlite3="${STAGING_INCLUDE}" \
        --with-openssl="${STAGING_INCLUDE}" \
        --with-crypto \
        --prefix="" \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    touch build/rules.mk
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
