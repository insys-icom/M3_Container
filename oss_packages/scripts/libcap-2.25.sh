#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="libcap-2.25"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="6666b839e5d46c2ad33fc8aa2ceb5f77"



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
    # setting MINLIBNAME to empty prevents shared object from being build
    make BUILD_CC="gcc" BUILD_CFLAGS="" MINLIBNAME="" LDFLAGS="${M3_LDFLAGS}" CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" CC="${M3_CROSS_COMPILE}gcc" AR="${AR}" RANLIB="${RANLIB}" NM="${NM}" || exit_failure "failed to build ${PKG_DIR}"
    make -i FAKEROOT="${PKG_INSTALL_DIR}" MINLIBNAME="" LIBDIR="/lib/" INCDIR="/include/" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i FAKEROOT="${STAGING_DIR}" MINLIBNAME="" LIBDIR="/lib/" INCDIR="/include/" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
