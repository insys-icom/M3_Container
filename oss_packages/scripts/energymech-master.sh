#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://github.com/MadCamel/energymech/archive/master.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="none"

# name of directory after extracting the archive in working directory
PKG_DIR="energymech-master"

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
    cd "${PKG_BUILD_DIR}"
    ./configure --without-debug --without-alias --without-botnet --without-dyncmd --without-chanban --without-newbie --without-profiling --without-seen --without-session --without-tcl --without-telnet --without-wingate --without-md5 --without-ctcp --without-dccfile --without-uptime --without-redirect --without-greet --without-perl --without-dynamode --without-web --without-note --without-notify --without-trivia --without-toybox --without-bounce --without-stats --without-rawdns --without-ircd_ext --without-idwrap --without-chanban --without-python
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    make ${M3_MAKEFLAGS}
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make install
    cp energymech "${STAGING_DIR}/bin"
}

. ${HELPERSDIR}/call_functions.sh
