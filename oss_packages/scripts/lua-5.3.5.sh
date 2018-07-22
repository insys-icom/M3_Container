#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="lua-5.3.5"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# PKG_DOWNLOAD="https://www.lua.org/ftp/lua-5.3.5.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="4f4b4f323fd3514a68e0ab3da8ce3455"



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
    true
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} \
        CC="${M3_CROSS_COMPILE}gcc" \
        CFLAGS="-Wall -Wextra -DLUA_COMPAT_5_2 -fPIC -ULUA_USE_READLINE ${M3_CFLAGS}" \
        LUA_LIBS="" \
        SYSCFLAGS="-DLUA_USE_LINUX" \
        SYSLDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        AR="${AR} rcu" \
        RANLIB="${RANLIB}" \
        NM="${NM}" \
        generic || exit_failure "failed to build ${PKG_DIR}"
    make local
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make INSTALL_TOP="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
