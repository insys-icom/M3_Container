#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="Python-3.6.0"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="82b143ebbf4514d7e05876bed7a6b1f5"

# Variable for the install path used in script
PYTHON_VERSION="python3.6"



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
    # Be sure you compiled these oss_packages first:
    #  - openssl
    #  - zlib
    #  - sqlite

    # compile Python for x86. This is only needed once in case there is not native python 3 in the SDK
    PYTHON_HOST="${PKG_BUILD_DIR}/Python_host"
    mkdir -P "${PYTHON_HOST}"
    cd "${PKG_BUILD_DIR}"
    ./configure --prefix="${PKG_BUILD_DIR}/Python_host" --with-fpectl --with-computed-gotos --with-libc= --without-ensurepip --without-lto

    make ${M3_MAKEFLAGS}
    make install

    rm "${PKG_BUILD_DIR}/Parser/"*".o"
    rm "${PKG_BUILD_DIR}/Programs/"*".o"

    # compile Python for target
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make distclean

    export PYTHONHOME="${PYTHON_HOST}"
    export PATH="${PATH}:${PYTHON_HOST}/bin"
    export CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    export ac_cv_file__dev_ptc=no
    export ac_cv_file__dev_ptmx=no
    export CXX

    # --enable-optimizations will increase the time for compilation significantly
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --build=i686-pc-linux-gnu --with-fpectl --enable-ipv6 --with-threads --with-computed-gotos --with-system-expat --with-lto --enable-shared --without-ensurepip # --enable-optimizations
}

compile()
{
    export PYTHON_HOST="${PKG_BUILD_DIR}/Python_host"
    export PYTHONHOME="${PYTHON_HOST}"
    export PYTHONPATH="${PYTHON_HOST}/lib/${PYTHON_VERSION}"
    export PATH="${PATH}:${PYTHON_HOST}/bin"
    PYTHON_FOR_BUILD="${PYTHON_HOST}/bin/${PYTHON_VERSION}"
    export STAGING_INCLUDE="${STAGING_INCLUDE}"
    export STAGING_LIB="${STAGING_LIB}"

    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    export PYTHON_HOST="${PKG_BUILD_DIR}/Python_host"
    export PYTHONHOME="${PYTHON_HOST}"
    export PYTHONPATH="${PYTHON_HOST}/lib/${PYTHON_VERSION}"
    export PATH="${PATH}:${PYTHON_HOST}/bin"
    PYTHON_FOR_BUILDPYTHON_FOR_BUILD="${PYTHON_HOST}/bin/${PYTHON_VERSION}"

    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"

    # remove the static lib
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/config-"*

    # remove directories which are not needed (like the included idle editor)
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/test"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/idlelib"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/lib2eto3"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/tkinter"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/distutils/command/wininst"*

    # remove all precompiled python bytecode
    find "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}" -name  __pycache__ | xargs  rm -Rf
}

. ${HELPERSDIR}/call_functions.sh
