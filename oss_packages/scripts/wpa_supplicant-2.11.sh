#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="wpa_supplicant-2.11"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
PKG_DOWNLOAD="https://w1.fi/releases/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="912ea06f74e30a8e36fbb68064d6cdff218d8d591db0fc5d75dee6c81ac7fc0a"



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
    echo -en "CONFIG_DRIVER_WEXT=y
CONFIG_DRIVER_WIRED=y
CONFIG_IEEE8021X_EAPOL=y
CONFIG_EAP_MD5=y
CONFIG_EAP_MSCHAPV2=y
CONFIG_EAP_TLS=y
CONFIG_EAP_PEAP=y
CONFIG_EAP_TTLS=y
CONFIG_EAP_GTC=y
CONFIG_EAP_OTP=y
CONFIG_EAP_SIM=y
CONFIG_EAP_AKA=y
CONFIG_EAP_AKA_PRIME=y
CONFIG_EAP_PSK=y
CONFIG_EAP_SAKE=y
CONFIG_EAP_GPSK=y
CONFIG_EAP_PAX=y
CONFIG_EAP_LEAP=y
CONFIG_EAP_IKEV2=y
CONFIG_EAP_PWD=y
" > wpa_supplicant/.config
}

compile()
{
    cd "${PKG_BUILD_DIR}"/wpa_supplicant

    CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    make "${M3_MAKEFLAGS}" CC="${M3_CROSS_COMPILE}gcc" || exit_failure "failed to build ${PKG_DIR}"

    make BINDIR="/sbin" DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"

    mkdir -p "${STAGING_DIR}/sbin"
    cp -av "${PKG_INSTALL_DIR}"/sbin/wpa_supplicant "${STAGING_DIR}"/sbin || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
    cp -av "${PKG_INSTALL_DIR}"/sbin/wpa_cli "${STAGING_DIR}"/sbin        || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
    cp -av "${PKG_INSTALL_DIR}"/sbin/wpa_passphrase "${STAGING_DIR}"/sbin || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
