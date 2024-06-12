#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="cJSON-1.7.18"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://github.com/DaveGamble/cJSON/archive/refs/tags/v${PKG_DIR##*-}.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="3aa806844a03442c00769b83e99970be70fbef03735ff898f4811dd03b9f5ee5"



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
    cmake \
        -DCMAKE_C_COMPILER=${M3_CROSS_COMPILE}gcc \
        -DCMAKE_C_FLAGS="${M3_CFLAGS} -fPIC -I${STAGING_INCLUDE} -L${STAGING_LIB}" \
        -DCMAKE_AR=${AR} \
        -DCMAKE_LINKER=${M3_CROSS_COMPILE}ld \
        -DCMAKE_STRIP=${M3_CROSS_COMPILE}strip \
        -DCMAKE_NM=${NM} \
        -DCMAKE_RANLIB=${RANLIB} \
        -DCMAKE_INSTALL_PREFIX="" \
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
}

. ${HELPERSDIR}/call_functions.sh
