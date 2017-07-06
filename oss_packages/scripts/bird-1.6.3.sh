#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="bird-1.6.3"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# ftp://bird.network.cz/pub/bird/bird-1.6.3.tar.gz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="63dd93a7a23c274fc5b7f2e37664bfb7"



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
    cp -a "${PKG_BUILD_DIR}" "${PKG_BUILD_DIR}/ipv6"
    cd "${PKG_BUILD_DIR}"

    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    ./configure --target="${M3_TARGET}" --host="${M3_TARGET}" --prefix="" --disable-client --sysconfdir="/etc" --localstatedir="/var" --disable-ipv6 #--enable-debug

    # again for IPv6
    cd "${PKG_BUILD_DIR}/ipv6"
    ./configure --target="${M3_TARGET}" --host="${M3_TARGET}" --prefix="" --disable-client --sysconfdir="/etc" --localstatedir="/var" --enable-ipv6 #--enable-debug
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install

    # again for IPv6
    cd "${PKG_BUILD_DIR}/ipv6"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
    cp "${PKG_BUILD_DIR}/install/sbin/"* "${STAGING_DIR}/sbin"
}

. ${HELPERSDIR}/call_functions.sh
