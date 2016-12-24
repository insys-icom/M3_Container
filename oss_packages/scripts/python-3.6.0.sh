#!/bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://www.python.org/ftp/python/3.6.0/Python-3.6.0.tar.xz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="82b143ebbf4514d7e05876bed7a6b1f5"

# name of directory after extracting the archive in working directory
PKG_DIR="Python-3.6.0"

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
    # compile Python for x86
    PYTHON_HOST="${PKG_BUILD_DIR}/Python_host"
    mkdir -P "${PYTHON_HOST}"
    cd "${PKG_BUILD_DIR}"
    ./configure --prefix="${PKG_BUILD_DIR}/Python_host" --with-fpectl --with-computed-gotos --with-libc= --without-ensurepip --without-lto

    make
    make install

    rm "${PKG_BUILD_DIR}/Parser/"*".o"
    rm "${PKG_BUILD_DIR}/Programs/"*".o"

    # compile Python for target
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    export PYTHONHOME="${PYTHON_HOST}"
    export PATH="${PATH}:${PYTHON_HOST}/bin"
    export CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_DIR}/usr/include/ncurses -I${STAGING_DIR}/usr/include/ncursesw"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    export ac_cv_file__dev_ptc=no
    export ac_cv_file__dev_ptmx=no
    export CXX

    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --build=i686-pc-linux-gnu --with-fpectl --with-libc= --without-ensurepip --enable-ipv6 --with-threads --with-computed-gotos --with-system-expat --with-lto --enable-shared

    #sed -e 's,\$(\([A-Za-z0-9_]*\)),\$\{\1\},g' < Misc/python-config.sh >python-config
}

compile()
{
    export PYTHONHOME="${PYTHON_HOST}"
    export PYTHONPATH="${PYTHON_HOST}/lib/python3.5"
    export PATH="${PATH}:${PYTHON_HOST}/bin"
    PYTHON_FOR_BUILD="${PYTHON_HOST}/bin/python3.5"
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"

    # remove all precompiled python bytecode
    find "${STAGING_DIR}/usr/local/lib/python3.5" -name  __pycache__ | xargs  rm -Rf
}

. ${HELPERSDIR}/call_functions.sh
