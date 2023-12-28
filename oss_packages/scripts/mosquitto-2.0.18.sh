#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="mosquitto-2.0.18"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# PKG_DOWNLOAD="https://mosquitto.org/files/source/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="d665fe7d0032881b1371a47f34169ee4edab67903b2cd2b4c083822823f4448a"



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

    CC="${M3_CROSS_COMPILE}gcc" \
    CXX=$CC \
    CROSS_COMPILE="" \
    CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -lcrypto -lssl" \
        make WITH_UUID=no WITH_EC=yes WITH_CJSON=yes WITH_DOCS:=no WITH_WEBSOCKETS:=yes \
        "${M3_MAKEFLAGS}" DESTDIR="${PKG_INSTALL_DIR}" install \
        || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    export CROSS_COMPILE=""
    export STRIP=armv7a-hardfloat-linux-gnueabi-strip
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
