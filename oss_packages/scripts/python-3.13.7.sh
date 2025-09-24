#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="Python-3.13.7"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.xz"

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="https://www.python.org/ftp/python/${PKG_DIR##*-}/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="5462f9099dfd30e238def83c71d91897d8caa5ff6ebc7a50f14d4802cdaaa79a"



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
    # compile Python for amd64. This is only needed once in case there is not native python 3.13
    AR_TARGET="${AR}"
    NM_TARGET="${NM}"
    RANLIB_TARGET="${RANLIB}"
    export AR=x86_64-pc-linux-gnu-gcc-ar
    export NM=x86_64-pc-linux-gnu-gcc-nm
    export RANLIB=x86_64-pc-linux-gnu-gcc-ranlib

    PYTHON_HOST="${PKG_BUILD_DIR}/Python_host"
    mkdir -P "${PYTHON_HOST}"
    cd "${PKG_BUILD_DIR}"
    ./configure \
        --prefix="${PYTHON_HOST}" \
        --with-ensurepip=no \
        --without-lto \
        --disable-test-modules \
		--without-readline \
		--disable-optimizations \
        || exit_failure "failed to configure Python for host"

    make "${M3_MAKEFLAGS}" || exit_failure "failed to build Python for host"
    make install || exit_failure "failed to install Python for host"

    ln -s "${PYTHON_HOST}/bin/python3.13" "${PYTHON_HOST}/bin/python3"
    rm "${PKG_BUILD_DIR}/Parser/"*".o"
    rm "${PKG_BUILD_DIR}/Programs/"*".o"

    # configure Python for target
    export AR="${AR_TARGET}"
    export NM="${NM_TARGET}"
    export RANLIB="${RANLIB_TARGET}"

    cd "${PKG_BUILD_DIR}"
    make distclean

    ac_cv_file__dev_ptc=no \
    ac_cv_file__dev_ptmx=no \
    ax_cv_c_float_words_bigendian=no \
    CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -Wno-implicit-function-declaration" \
    CPPFLAGS="${CFLAGS}" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    CXX="" \
    ./configure \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --build=i686-pc-linux-gnu \
        --enable-ipv6 \
        --with-lto \
        --with-ssl-default-suites=openssl \
        --disable-test-modules \
        --with-openssl="${STAGING_DIR}" \
        --with-build-python="${PYTHON_HOST}/bin/python3" \
        --without-static-libpython \
        || exit_failure "failed to configure ${PKG_DIR}"

    # skip checksharedmods test
    sed -i 's|gdbhooks Programs/_testembed scripts checksharedmods rundsymutil|gdbhooks Programs/_testembed scripts rundsymutil|' "${PKG_BUILD_DIR}/Makefile"
}

compile()
{
    export STAGING_INCLUDE="${STAGING_INCLUDE}"
    export STAGING_LIB="${STAGING_LIB}"
    export PYTHON_HOST="${PKG_BUILD_DIR}/Python_host"

    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" commoninstall || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" commoninstall || exit_failure "failed to install ${PKG_DIR}"

    # Variable for the install path used in script
    PYTHON_VERSION="python3.13"

    # remove the static lib
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/config-"*

    # remove directories which are not needed (like the included idle editor)
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/__pychache__"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/__phello__"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/idlelib"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/lib2to3"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/tkinter"
    rm -Rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/turtledemo"
}

. ${HELPERSDIR}/call_functions.sh
