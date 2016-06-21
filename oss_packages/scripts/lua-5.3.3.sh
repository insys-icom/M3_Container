#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://www.lua.org/ftp/lua-5.3.3.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="703f75caa4fdf4a911c1a72e67a27498"

# name of directory after extracting the archive in working directory
PKG_DIR="lua-5.3.3"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

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
    make ${M3_MAKEFLAGS} CC="${M3_CROSS_COMPILE}gcc" CFLAGS="-Wall -Wextra -DLUA_COMPAT_5_2 -fPIC -ULUA_USE_READLINE ${M3_CFLAGS}" LUA_LIBS="" SYSCFLAGS="-DLUA_USE_LINUX" SYSLDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" AR="${AR} rcu" RANLIB="${RANLIB}" NM="${NM}" generic || exit_failure "failed to build ${PKG_DIR}"
    # remove static binaries
    rm "${PKG_BUILD_DIR}/src/lua" "${PKG_BUILD_DIR}/src/luac"
    # and their object files
    rm "${PKG_BUILD_DIR}/src/lua.o" "${PKG_BUILD_DIR}/src/luac.o"
    # create a shared object
    ${M3_CROSS_COMPILE}gcc ${M3_LDFLAGS} "${PKG_BUILD_DIR}/src/"*.o -fPIC -shared -Wl,-soname,liblua.so -lm -o "${PKG_BUILD_DIR}/src/liblua.so"
    # rebuild lua and link agaist the shared object
    ${M3_CROSS_COMPILE}gcc ${M3_LDFLAGS} -Wall -Wextra -DLUA_COMPAT_5_2 -fPIC -ULUA_USE_READLINE ${M3_CFLAGS} "${PKG_BUILD_DIR}/src/lua.c" -o "${PKG_BUILD_DIR}/src/lua" -llua -L"${PKG_BUILD_DIR}/src/"
    # touch luac, because it wont build that easy and we don't care about it
    touch "${PKG_BUILD_DIR}/src/luac"
    echo recompiled shared
    make INSTALL_TOP="${PKG_INSTALL_DIR}" install
    cp -a "${PKG_BUILD_DIR}/src/liblua.so" "${PKG_INSTALL_DIR}/lib"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make INSTALL_TOP="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
    cp -a "${PKG_BUILD_DIR}/src/liblua.so" "${STAGING_DIR}/lib"
}

. ${HELPERSDIR}/call_functions.sh
