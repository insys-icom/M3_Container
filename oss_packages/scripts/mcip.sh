#!/bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="http://downloads.sourceforge.net/project/mcip/${PKG_ARCHIVE_FILE}?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmcip%2F&ts=1465459732&use_mirror=liquidtelecom"
PKG_DOWNLOAD="http://downloads.sourceforge.net/project/mcip/mcip_2016.01.19.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmcip%2F&ts=1465459732&use_mirror=liquidtelecom"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="5b2ec1b3c7e79d27fc708ace9d4b2bc0"

# name of directory after extracting the archive in working directory
PKG_DIR="mcip"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="mcip_2016.01.19.tar.gz"


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
    CFLAGS="${M3_CFLAGS}" CC="${M3_CROSS_COMPILE}gcc" STRIP="touch" make -C libmcip || exit_failure "failed to build ${PKG_DIR}"
    CFLAGS="${M3_CFLAGS}" CC="${M3_CROSS_COMPILE}gcc" STRIP="touch" make -C src/mcip || exit_failure "failed to build ${PKG_DIR}"
    CFLAGS="${M3_CFLAGS}" CC="${M3_CROSS_COMPILE}gcc" STRIP="touch" make -C src/console || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    mkdir -p "${STAGING_DIR}"/include
    mkdir -p "${STAGING_DIR}"/lib
    mkdir -p "${STAGING_DIR}"/usr/bin
    cp "src/mcip/mcip" "${STAGING_DIR}/usr/bin/mcip"
    cp "src/console/console" "${STAGING_DIR}/usr/bin/console"
    cp "libmcip/libmcip.so.1.0" "${STAGING_DIR}/lib/libmcip.so"

    cp "include/libmcip.h" "${STAGING_DIR}/include"
    cp "include/mcip.h" "${STAGING_DIR}/include"
    cp "include/mcip_common.h" "${STAGING_DIR}/include"
}

uninstall_staging()
{
    rm "${STAGING_DIR}/usr/bin/mcip"
    rm "${STAGING_DIR}/usr/bin/console"
    rm "${STAGING_DIR}/lib/libmcip.so.1.0"

    rm "${STAGING_DIR}/include/libmcip.h"
    rm "${STAGING_DIR}/include/mcip.h"
    rm "${STAGING_DIR}/include/mcip_common.h"

    rm "${STAGING_DIR}/lib/libmcip.so.1"
    rm "${STAGING_DIR}/lib/libmcip.so"
}

. ${HELPERSDIR}/call_functions.sh
