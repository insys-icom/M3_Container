#!/bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="ftp://ftp.dante.de/pub/tex/graphics/gnuplot/5.0.4/gnuplot-5.0.4.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="cb228f60ae152712ffde0db5de346c40"

# name of directory after extracting the archive in working directory
PKG_DIR="gnuplot-5.0.4"

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
    #export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    export CC_FOR_BUILD="${M3_CROSS_COMPILE}gcc"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix="" --disable-largefile --without-lua --with-readline=builtin
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"

    # do not compile stuff in docs and demo, as this will fail when cross compiling
    sed 's/SUBDIRS = config m4 term src docs $(LISPDIR) man demo tutorial share/SUBDIRS = config m4 term src $(LISPDIR) man tutorial share/' -i Makefile

    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
