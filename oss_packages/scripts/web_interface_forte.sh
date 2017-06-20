#! /bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="web_interface-1.0"

TARGET=web_interface_forte

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
	:
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"

    make ${M3_MAKEFLAGS} $(TARGET) || exit_failure "failed to build $(TARGET)"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp $(TARGET) "${STAGING_DIR}/bin"
}

. ${HELPERSDIR}/call_functions.sh