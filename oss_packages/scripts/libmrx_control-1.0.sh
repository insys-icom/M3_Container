#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/closed_sources/libmrx_control-1.0.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="1aebcd4010fcb0cf277df5e451ea22d7"

# name of directory after extracting the archive in working directory
PKG_DIR="libmrx_control-1.0"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

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
	if [ ! -d "${PKG_BUILD_DIR}" ]; then
		mkdir -p "${PKG_BUILD_DIR}"
    fi
    
    if [ ! -d "${STAGING_LIB}" ]; then
		mkdir -p "${STAGING_LIB}"
    fi
    
    if [ ! -d "${STAGING_INCLUDE}" ]; then
		mkdir -p "${STAGING_INCLUDE}"
    fi
}

compile()
{
    copy_overlay
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp lib/* "${STAGING_LIB}"
    cp include/* "${STAGING_INCLUDE}"
}

. ${HELPERSDIR}/call_functions.sh
