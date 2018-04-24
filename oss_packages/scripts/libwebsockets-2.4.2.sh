#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="libwebsockets-2.4.2"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://github.com/warmcat/libwebsockets/archive/v2.4.2.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="b64300541128baa18828620187453efb"



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

    echo '
        set(CMAKE_C_COMPILER ${M3_CROSS_COMPILE}gcc)
        set(CMAKE_C_FLAGS="${CFLAGS} -fPIC -I${STAGING_INCLUDE} -L${STAGING_LIB}")
        set(CMAKE_AR=${AR})
        set(CMAKE_LINKER=${M3_CROSS_COMPILE}ld)
        set(CMAKE_STRIP=${M3_CROSS_COMPILE}strip)
        set(CMAKE_NM=${NM})
        set(CMAKE_RANLIB=${RANLIB})
        set(CMAKE_SHARED_LINKER_FLAGS="${LDFLAGS}")
        set(CMAKE_EXE_LINKER_FLAGS="${M3_LDFLAGS}")
        set(CMAKE_MODULE_LINKER_FLAGS="${M3_LDFLAGS}")
        set(CMAKE_INSTALL_PREFIX="")
        ' > cross_compile_file.txt

    cmake -DCMAKE_TOOLCHAIN_FILE=cross_compile_file.txt
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
