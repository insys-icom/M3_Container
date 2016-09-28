#!/bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="http://downloads.sourceforge.net/project/expat/expat/${PKG_DIR##*-}/${PKG_ARCHIVE_FILE}?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fexpat%2Ffiles%2Flatest%2Fdownload%3Fsource%3Dfiles&ts=1474882995&use_mirror=netcologne"
PKG_DOWNLOAD="http://downloads.sourceforge.net/project/expat/expat/2.2.0/expat-2.2.0.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fexpat%2Ffiles%2Flatest%2Fdownload%3Fsource%3Dfiles&ts=1474882995&use_mirror=netcologne"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="2f47841c829facb346eb6e3fab5212e2"

# name of directory after extracting the archive in working directory
PKG_DIR="expat-2.2.0"

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
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix=""
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"    
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
