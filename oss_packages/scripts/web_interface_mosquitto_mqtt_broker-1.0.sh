#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="web_interface-1.0"

TARGET="web_interface_mosquitto_mqtt_broker"

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
    copy_overlay
    cd "${PKG_BUILD_DIR}"

    ln -sf configuration_mqtt_broker.c configuration.c
    ln -sf settings_defines_mqtt_broker.h settings_defines.h
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" "${TARGET}" || exit_failure "failed to build ${TARGET}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp "${TARGET}" "${STAGING_DIR}/bin"
}

. ${HELPERSDIR}/call_functions.sh
