#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="i2c-tools-3.1.2"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="7104a1043d11a5e2c7b131614eb1b962"



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
    true
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} CFLAGS="${M3_CFLAGS}" LDFLAGS="${M3_LDFLAGS}" CC="${M3_CROSS_COMPILE}gcc" || exit_failure "failed to build ${PKG_DIR}"

    #export PYTHONXCPREFIX="${PKG_BUILD_DIR}/../Python-2.7.12/install"
    export PYTHONXCPREFIX="${STAGING_DIR}"
    export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    export CC="${CROSS_COMPILE}gcc -pthread"
    export LDSHARED="${CC} -shared"
    #export LDFLAGS="-L${STAGING_LIB}"
    export LDFLAGS="-L${STAGING_DIR}/usr/local/lib"

    make EXTRA="py-smbus" prefix="/" DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make prefix=/ DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"

    echo " "
    echo "******************************************"
    echo "* If you want to use the py-smbus, you will have to copy "
    echo "* ${PKG_BUILD_DIR}/py-smbus/build/lib.linux-x86_64-2.7/smbus.so"
    echo "* manually into your python container directory lib/site-packages"
}

. ${HELPERSDIR}/call_functions.sh
