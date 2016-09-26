#!/bin/sh

SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_DIR="dnsmasq-2.76"
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"
PKG_DOWNLOAD="http://www.thekelleys.org.uk/dnsmasq/${PKG_ARCHIVE_FILE}"
PKG_CHECKSUM="00f5ee66b4e4b7f14538bf62ae3c9461"

PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    echo "############################################################"
    echo "This needs nettle, so build that first!"
    echo "############################################################"
    true
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    PKG_CONFIG_PATH="${STAGING_LIB}/pkgconfig" make ${M3_MAKEFLAGS} PREFIX=/ CC="${M3_CROSS_COMPILE}gcc" "CFLAGS=${M3_CFLAGS} -I${STAGING_INCLUDE}" "LDFLAGS=${M3_LDFLAGS} -L${STAGING_LIB}" \
    'COPTS= -DNO_AUTH -DNO_CONNTRACK -DNO_DBUS -DNO_IDN -DHAVE_DNSSEC -DHAVE_DNSSEC_STATIC -DNO_GMP' CONFFILE=/etc/dnsmasq.conf all || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cp "${PKG_BUILD_DIR}/src/dnsmasq" "${STAGING_DIR}/sbin"
}

. ${HELPERSDIR}/call_functions.sh
