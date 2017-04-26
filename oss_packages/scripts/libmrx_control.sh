#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="none"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="none"

# name of directory after extracting the archive in working directory
PKG_DIR="libmrx_control"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="none"

SCRIPTSDIR="$(dirname $0)"
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR="$(realpath ${SCRIPTSDIR}/../..)"

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
	export CFLAGS="${M3_CFLAGS}"
    export LDFLAGS="${M3_LDFLAGS}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    
    export CFLAGS="${M3_CFLAGS}"
    export LDFLAGS="${M3_LDFLAGS}"
    export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    
    make ${M3_MAKEFLAGS} INCLUDES="-I${STAGING_INCLUDE}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp libmrx_control.so "${STAGING_LIB}"
    cp Include/* "${STAGING_INCLUDE}"
}

. ${HELPERSDIR}/call_functions.sh
