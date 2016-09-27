#!/bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://busybox.net/downloads/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="2eaae519cac1143bcf583636a745381f"

# name of directory after extracting the archive in working directory
PKG_DIR_ORIG="busybox-1.24.2"
PKG_DIR="${PKG_DIR_ORIG}_mini"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR_ORIG}.tar.bz2"


SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"
BBOX_BUILD_DIR="${PKG_BUILD_DIR}/build/system"

unpack()
{
    echo "unpacking ${PKG_ARCHIVE_FILE}"
    if ! [ "${PKG_ARCHIVE_FILE}" = "none" ] ; then
        tar -C ${BUILD_DIR} -xf ${PKG_ARCHIVE} || exit_failure "unable to extract ${PKG_ARCHIVE}"
        mv "${BUILD_DIR}/${PKG_DIR_ORIG}" "${BUILD_DIR}/${PKG_DIR}"
        [ -d "${PKG_BUILD_DIR}" ] || exit_failure "${PKG_BUILD_DIR} was not found in archive"
    fi
    mkdir -p "${BBOX_BUILD_DIR}"
}

configure()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} V=1 O="${BBOX_BUILD_DIR}" CONFIG_EXTRA_CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" CONFIG_EXTRA_LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" AR="${AR}" RANLIB="${RANLIB}" NM="${NM}" CROSS_COMPILE=${M3_CROSS_COMPILE}
}

menuconfig()
{
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} V=1 O="${BBOX_BUILD_DIR}" CONFIG_EXTRA_CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" CONFIG_EXTRA_LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" AR="${AR}" RANLIB="${RANLIB}" NM="${NM}" CROSS_COMPILE=${M3_CROSS_COMPILE} menuconfig
    DST_FILE=$(echo "${BBOX_BUILD_DIR}/.config" | sed "s#${BUILD_DIR}#${SOURCES_DIR}#")
    cp -a "${BBOX_BUILD_DIR}/.config" "${DST_FILE}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} V=1 O="${BBOX_BUILD_DIR}" CONFIG_EXTRA_CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" CONFIG_EXTRA_LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" AR="${AR}" RANLIB="${RANLIB}" NM="${NM}" CROSS_COMPILE=${M3_CROSS_COMPILE} install || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    mkdir "${STAGING_DIR}/bin/"
    cp "${BBOX_BUILD_DIR}/busybox" "${STAGING_DIR}/bin/"
    cp "${BBOX_BUILD_DIR}/busybox.links" "${STAGING_DIR}/bin/"
}

uninstall_staging()
{
    rm -vf "${STAGING_DIR}/bin/busybox"
    rm -vf "${STAGING_DIR}/bin/busybox.links"
}

. ${HELPERSDIR}/call_functions.sh
