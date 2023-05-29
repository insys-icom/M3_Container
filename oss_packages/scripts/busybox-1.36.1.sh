#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="busybox-1.36.1"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

# download link for the sources to be stored in dl directory (use "none" if empty)
#PKG_DOWNLOAD="https://busybox.net/downloads/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="0fc591bc9f4e365dfd9ade0014f32561"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"


BBOX_BUILD_DIR="${PKG_BUILD_DIR}/build"
BBOX_OVERLAY_CONFIG=$(echo "${BBOX_BUILD_DIR}/.config${BUILD_SUFFIX}" | sed "s#${BUILD_DIR}#${SOURCES_DIR}#")

configure()
{
    cd "${PKG_BUILD_DIR}"
    cp -av "${BBOX_OVERLAY_CONFIG}" "${BBOX_BUILD_DIR}/.config"

    make ${M3_MAKEFLAGS} \
         V=1 \
         O="${BBOX_BUILD_DIR}" \
         CONFIG_EXTRA_CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
         CONFIG_EXTRA_LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -Wl,-rpath-link -Wl,${GCC_LIB_DIR}" \
         AR="${AR}" \
         RANLIB="${RANLIB}" \
         NM="${NM}" \
         CROSS_COMPILE=${M3_CROSS_COMPILE} \
         oldconfig || exit_failure "failed to configure ${PKG_DIR}"
}

menuconfig()
{
    cd "${PKG_BUILD_DIR}"
    cp -av "${BBOX_OVERLAY_CONFIG}" "${BBOX_BUILD_DIR}/.config"

    make ${M3_MAKEFLAGS} \
         V=1 \
         O="${BBOX_BUILD_DIR}" \
         CONFIG_EXTRA_CFLAGS="${M3_CFLAGS} \
         -I${STAGING_INCLUDE}" \
         CONFIG_EXTRA_LDFLAGS="${M3_LDFLAGS} \
         -L${STAGING_LIB}" \
         AR="${AR}" \
         RANLIB="${RANLIB}" \
         NM="${NM}" \
         CROSS_COMPILE=${M3_CROSS_COMPILE} \
         menuconfig

    cp -av "${BBOX_BUILD_DIR}/.config" "${BBOX_OVERLAY_CONFIG}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} \
         V=1 \
         O="${BBOX_BUILD_DIR}" \
         CONFIG_EXTRA_CFLAGS="${M3_CFLAGS} \
         -I${STAGING_INCLUDE}" \
         CONFIG_EXTRA_LDFLAGS="${M3_LDFLAGS} \
         -L${STAGING_LIB}" \
         AR="${AR}" \
         RANLIB="${RANLIB}" \
         NM="${NM}" \
         CROSS_COMPILE=${M3_CROSS_COMPILE} \
         install || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    [ "${RESCUE}" = "1" ] && return
    mkdir -p "${STAGING_DIR}/bin/"
    cp "${BBOX_BUILD_DIR}/busybox" "${STAGING_DIR}/bin/" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
    cp "${BBOX_BUILD_DIR}/busybox.links" "${STAGING_DIR}/bin/" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

uninstall_staging()
{
    rm -vf "${STAGING_DIR}/bin/busybox"
    rm -vf "${STAGING_DIR}/bin/busybox.links"
}

. ${HELPERSDIR}/call_functions.sh
