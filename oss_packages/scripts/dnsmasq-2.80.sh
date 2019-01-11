#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="dnsmasq-2.80"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="http://www.thekelleys.org.uk/dnsmasq/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="e040e72e6f377a784493c36f9e788502"



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
    PKG_CONFIG_PATH="${STAGING_LIB}/pkgconfig" \
        make ${M3_MAKEFLAGS} \
        PREFIX=/ \
        CC="${M3_CROSS_COMPILE}gcc" \
        CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        COPTS=' -DNO_AUTH -DNO_CONNTRACK -DNO_DBUS -DNO_IDN -DNO_LUASCRIPT -DNO_DNSSEC -DNO_DNSSEC_STATIC -DNO_GMP' \
        CONFFILE="/etc/dnsmasq.conf" \
        all

    if [ $? -ne 0 ]; then
        echo "############################################################"
        echo "This needs the following packages, so build these first!"
        echo "  nettle"
        echo "############################################################"
        exit_failure "failed to compile ${PKG_DIR}"
    fi
}

install_staging()
{
    cp "${PKG_BUILD_DIR}/src/dnsmasq" "${STAGING_DIR}/sbin" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh

