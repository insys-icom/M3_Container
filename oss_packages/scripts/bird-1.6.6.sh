#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="bird-1.6.6"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="ftp://bird.network.cz/pub/bird/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="f2159ce3fb973fb124440725541cf800"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    mkdir -p "${PKG_BUILD_DIR}/ipv6" || exit_failure "failed to configure ${PKG_DIR}"
    tar c -C "${PKG_BUILD_DIR}" --exclude='./ipv6' . | tar x -C "${PKG_BUILD_DIR}/ipv6" || exit_failure "failed to configure ${PKG_DIR}"
    cd "${PKG_BUILD_DIR}"

    # bird will not compile with LTO optimization
    # beside from a hardcoded "ar" in the Rules.in there are missing "extern"s in headers and some multiple definitions
    CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE} -fno-lto" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -fno-lto" \
    ./configure --target="${M3_TARGET}" \
                --host="${M3_TARGET}" \
                --prefix="" \
                --disable-client \
                --sysconfdir="/etc" \
                --localstatedir="/var" \
                --disable-ipv6 || exit_failure "failed to configure ${PKG_DIR}"

    # again for IPv6
    cd "${PKG_BUILD_DIR}/ipv6"

    CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE} -fno-lto" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -fno-lto" \
    ./configure --target="${M3_TARGET}" \
                --host="${M3_TARGET}" \
                --prefix="" \
                --disable-client \
                --sysconfdir="/etc" \
                --localstatedir="/var" \
                --enable-ipv6 || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"

    # again for IPv6
    cd "${PKG_BUILD_DIR}/ipv6"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    mkdir -p "${STAGING_DIR}/sbin"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
    cp "${PKG_BUILD_DIR}/install/sbin/"* "${STAGING_DIR}/sbin" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
