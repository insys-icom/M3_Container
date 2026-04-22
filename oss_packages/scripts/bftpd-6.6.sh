#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="bftpd-6.6"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://sourceforge.net/projects/bftpd/files/bftpd/${PKG_DIR}/${PKG_ARCHIVE_FILE}/download"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="a867ba93a608cccb60944e1fae00e52b463f416b09235f87a31c023b296ac12e"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}"/scripts/common_settings.sh
. "${HELPERSDIR}"/functions.sh
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

unpack()
{
    ! [ -e "${PKG_BUILD_DIR}" ] && mkdir -p "${PKG_BUILD_DIR}"
    ! [ -e "${TARGET_DIR}" ] && mkdir -p "${TARGET_DIR}"

    tar -C "${BUILD_DIR}" -xf "${PKG_ARCHIVE}" || exit_failure "Unable to extract ${PKG_ARCHIVE}"
    [ -d "${PKG_BUILD_DIR}" ] || exit_failure "${PKG_BUILD_DIR} was not found in archive"

    rm -Rf "${PKG_BUILD_DIR}"
    mv $(echo "${PKG_BUILD_DIR}" | cut -d'-' -f1) "${PKG_BUILD_DIR}"
    copy_overlay
}

configure()
{
    cd "${PKG_BUILD_DIR}"
    CPPFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -fcommon -Wno-implicit-int" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    ac_cv_prog_cc_works=yes CC="${M3_CROSS_COMPILE}gcc" \
        ./configure \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --enable-libz \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    CPPFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}  -fcommon" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    CC="${M3_CROSS_COMPILE}gcc" \
        make "${M3_MAKEFLAGS}" LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp bftpd.conf "${STAGING_DIR}/etc"
    cp bftpd "${STAGING_DIR}/bin"
}

. ${HELPERSDIR}/call_functions.sh
