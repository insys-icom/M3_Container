#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="openssl-1.1.1n"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
#PKG_DOWNLOAD="https://www.openssl.org/source/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="2aad5635f9bb338bc2c6b7d19cbc9676"



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

    if [ "${M3_TARGET}" = "x86_64-pc-linux-gnu" ] ; then
        OPENSSL_CONFIGURE_TARGET="linux-x86_64"
    else
        if [ "${BUILD_TARGET}" = "TEST" "${M3_TARGET}" = "x86_64-pc-linux-gnu" ] ; then
            OPENSSL_CONFIGURE_TARGET="linux-x86"
        else
            OPENSSL_CONFIGURE_TARGET="linux-armv4"
        fi
    fi

    CFLAGS="${M3_CFLAGS}" \
    LDFLAGS="${M3_LDFLAGS}" \
    AR="${AR}" \
    RANLIB="gcc-ranlib" \
    NM="${NM}" \
    ./Configure ${OPENSSL_CONFIGURE_TARGET} \
                no-camellia \
                no-seed \
                no-hw \
                no-ssl \
                no-ssl3 \
                --cross-compile-prefix="${M3_CROSS_COMPILE}" \
                --prefix="${PKG_INSTALL_DIR}" \
                --openssldir="${PKG_INSTALL_DIR}/ssl" \
                shared

    if [ $? -ne 0 ]; then
        exit_failure "failed to configure ${PKG_DIR}"
    fi
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make  ${M3_MAKEFLAGS}  \
         AR="${AR}" \
         NM="${NM}" \
         RANLIB="gcc-ranlib" \
         V=1 || exit_failure "failed to build ${PKG_DIR}"
    make install_sw || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cp -rv ${PKG_INSTALL_DIR}/* ${STAGING_DIR} || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

uninstall_staging()
{
    [ -d "${PKG_INSTALL_DIR}" ]
    find "${PKG_INSTALL_DIR}" -type f | sed "s|^${PKG_INSTALL_DIR}|${STAGING_DIR}|" | xargs rm -vf
    find "${PKG_INSTALL_DIR}" -type l | sed "s|^${PKG_INSTALL_DIR}|${STAGING_DIR}|" | xargs rm -vf
    rm -vrf "${STAGING_DIR}/include/openssl"
    rm -vrf "${STAGING_DIR}/lib/engines-1.1"
    rm -vrf "${STAGING_DIR}/share/doc/openssl"
    rm -vrf "${STAGING_DIR}/ssl"
}

. ${HELPERSDIR}/call_functions.sh
