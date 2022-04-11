#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="Python-3.10.4"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://www.python.org/ftp/python/${PKG_DIR##*-}/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="21f2e113e087083a1e8cf10553d93599"

# Variable for the install path used in script
PYTHON_VERSION="python3.10"



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
    make distclean

    # --enable-optimizations disabling this will increase the time for compilation significantly
    ac_cv_file__dev_ptc=no \
    ac_cv_file__dev_ptmx=no \
    ax_cv_c_float_words_bigendian=no \
    CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_INCLUDE}/ncursesw" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    CXX="" \
    ./configure \
        --target=${M3_TARGET} \
        --host=${M3_TARGET} \
        --build=i686-pc-linux-gnu \
        --enable-ipv6 \
        --with-computed-gotos \
        --with-system-expat \
        --with-lto \
        --without-doc-strings \
        --enable-shared \
        --with-ssl-default-suites=openssl \
        --with-openssl="${STAGING_DIR}" \
        --with-readline \
        --without-ensurepip || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    export STAGING_INCLUDE="${STAGING_INCLUDE}"
    export STAGING_LIB="${STAGING_LIB}"

    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"

    # remove the static lib
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/config-"*

    # remove directories which are not needed (like the included idle editor)
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/test"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/ensurepip"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/ctypes/test"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/distutils/tests"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/idlelib"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/lib2to3"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/tkinter"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/turtledemo"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/unittest"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/sqlite3/test"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/distutils/command/wininst"*

    # remove all precompiled python bytecode
    find "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}" -name  __pycache__ | xargs  rm -Rf
}

. ${HELPERSDIR}/call_functions.sh
