#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="minetest-0.4.17.1"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# https://github.com/minetest/minetest/archive/stable-0.4.zip
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="0eed1c88dab96fcf0f3aba67fcdf92e8"



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
    # make sure no lua libs or headers are rootfs_staging, otherwise minetest will link against those
    cd "${PKG_BUILD_DIR}"
    cmake . \
        -DCMAKE_SYSTEM_NAME=Linux \
        -DCMAKE_C_COMPILER=/usr/bin/armv7a-hardfloat-linux-gnueabi-gcc \
        -DCMAKE_CXX_COMPILER=/usr/bin/armv7a-hardfloat-linux-gnueabi-g++ \
        -DCMAKE_CXX_FLAGS="-lssl -lcrypto -lnghttp2 -L${STAGING_LIB} -L${STAGING_DIR}/usr/local/lib" \
        -DCMAKE_FIND_ROOT_PATH="${STAGING_DIR}" \
        -DIRRLICHT_INCLUDE_DIR="${PKG_BUILD_DIR}/../irrlicht-1.8.4/include" \
        -DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER \
        -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY \
        -DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY \
        -DCMAKE_VERBOSE_MAKEFILE=TRUE \
        -DRUN_IN_PLACE=TRUE \
        -DBUILD_CLIENT=FALSE \
        -DBUILD_SERVER=TRUE \
        -DENABLE_SOUND=FALSE \
        -DENABLE_CURSES=FALSE \
        -DENABLE_FREETYPE=TRUE \
        -DENABLE_GETTEXT=FALSE \
        -DENABLE_GLES=FALSE \
        -DENABLE_LEVELDB=FALSE \
        -DENABLE_POSTGRESQL=FALSE \
        -DENABLE_REDIS=FALSE \
        -DENABLE_SPATIAL=FALSE \
        -DENABLE_LUAJIT=TRUE \
        -DENABLE_SYSTEM_GMP=TRUE \
        -DENABLE_CURL=TRUE \
        -DDOXYGEN_EXECUTABLE=FALSE \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
