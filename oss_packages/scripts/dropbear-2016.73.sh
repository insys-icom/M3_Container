#! /bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://matt.ucc.asn.au/dropbear/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://matt.ucc.asn.au/dropbear/dropbear-2016.73.tar.bz2"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="8d6d78ce60ca52350ec04fcbd711ce9b"

# name of directory after extracting the archive in working directory
PKG_DIR="dropbear-2016.73"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"


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
    cd "${PKG_BUILD_DIR}"
    export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    export CFLAGS="${M3_CFLAGS}  -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS}  -L${STAGING_LIB}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix="" --disable-lastlog --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx --enable-pam
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    make ${M3_MAKEFLAGS} PROGRAMS="dbclient dropbear dropbearconvert dropbearkey scp" MULTI=1 || exit_failure "failed to build ${PKG_DIR}"
    # this will fail, because install wants to run sshd
    make PROGRAMS="dbclient dropbear dropbearconvert dropbearkey scp" MULTI=1 DESTDIR="${PKG_INSTALL_DIR}" -i install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" PROGRAMS="dbclient dropbear dropbearconvert dropbearkey scp" MULTI=1 install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
