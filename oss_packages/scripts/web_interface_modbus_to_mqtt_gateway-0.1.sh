#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="none"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="none"

# name of directory after extracting the archive in working directory
PKG_DIR="web_interface-0.1"

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

    mv configuration_modbus_mqtt.c configuration.c
    rm configuration_mqtt_broker.c

    mv settings_defines_modbus_mqtt.h settings_defines.h
    rm settings_defines_mqtt_broker.h

    make clean
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
