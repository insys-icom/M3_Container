#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="1dbcc848b4cd8399a8199d000f9f823c"

# name of directory after extracting the archive in working directory
PKG_DIR="Python-2.7.11"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

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
    export CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_INCLUDE}/ncurses -I${STAGING_INCLUDE}/ncursesw"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} "
    export ac_cv_file__dev_ptc=no
    export ac_cv_file__dev_ptmx=yes
    export CXX

    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --build=i686-pc-linux-gnu --prefix="" --with-fpectl --enable-shared --enable-ipv6 --with-threads --enable-unicode=ucs4 --with-computed-gotos --with-system-expat
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    touch Include/graminit.h Python/graminit.c
    #make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    #make DESTDIR="${PKG_INSTALL_DIR}" sharedinstall
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cp -a "${PKG_INSTALL_DIR}/"* "${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
