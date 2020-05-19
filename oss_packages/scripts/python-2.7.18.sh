#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="Python-2.7.18"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
# https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="fd6cc8ec0a78c44036f825e739f36e5a"



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
    copy_overlay

    cd "${PKG_BUILD_DIR}"
    CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_DIR}/include/ncurses -I${STAGING_DIR}/include/ncursesw" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    CPPFLAGS="-I${STAGING_INCLUDE} -I${STAGING_DIR}/include/ncurses -I${STAGING_DIR}/include/ncursesw" \
    ac_cv_file__dev_ptc=no \
    ac_cv_file__dev_ptmx=no \
    CXX=""\
    ./configure \
        --target=${M3_TARGET} \
        --host=${M3_TARGET} \
        --build=i686-pc-linux-gnu \
        --with-fpectl \
        --enable-ipv6 \
        --with-threads \
        --enable-unicode \
        --with-computed-gotos \
        --with-system-expat \
        --with-lto \
        --enable-shared || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    echo "******************************************"
    echo "* Compiling and installing to: ${PKG_INSTALL_DIR}"
    cd "${PKG_BUILD_DIR}"
    touch Include/graminit.h Python/graminit.c
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    echo "******************************************"
    echo "* Installing to staging: ${STAGING_DIR}"
    rm -rf "${STAGING_DIR}/usr/local/lib/libpython2"*
    cp -r "${PKG_INSTALL_DIR}/"* "${STAGING_DIR}"

    # remove all precompiled python bytecode
    #find "${STAGING_DIR}/usr/local/lib/python2.7" -name  *.pyo | xargs  rm -Rf
    #find "${STAGING_DIR}/usr/local/lib/python2.7" -name  *.pyc | xargs  rm -Rf
}

. ${HELPERSDIR}/call_functions.sh
