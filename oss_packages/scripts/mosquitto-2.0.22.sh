#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="mosquitto-2.0.22"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# PKG_DOWNLOAD="https://mosquitto.org/files/source/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="2f752589ef7db40260b633fbdb536e9a04b446a315138d64a7ff3c14e2de6b68"



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
        make \
            "${M3_MAKEFLAGS}" \
            WITH_UUID=no \
            WITH_EC=yes \
            WITH_CJSON=yes \
            WITH_DOCS:=no \
            WITH_WEBSOCKETS:=yes \
            DESTDIR="${PKG_INSTALL_DIR}" install \
            || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
