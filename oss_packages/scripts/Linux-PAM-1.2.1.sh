#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="Linux-PAM-1.2.1"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="9dc53067556d2dd567808fd509519dd6"



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
    # export ac_cv_lib_fl_yywrap=no
    # export ac_cv_lib_l_yywrap=no
    # YFLAGS=--noyywrap
    export CFLAGS="${M3_CFLAGS}"
    export LDFLAGS="${M3_LDFLAGS}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --disable-selinux --disable-nls --disable-regenerate-docu --disable-nis --enable-db=no --disable-audit --disable-cracklib --disable-lckpwdf --disable-prelude --disable-largefile --disable-pie --prefix="" --disable-rpath --includedir="/include/security"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    # export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    # work around undefined yywrap error, cuz YFLAGS=--noyywrap didn't help
    touch conf/pam_conv1/pam_conv_l.o
    touch conf/pam_conv1/pam_conv_y.o
    touch conf/pam_conv1/pam_conv1
    touch doc/specs/parse_l.o doc/specs/parse_y.o
    echo -e '#!/bin/sh\ntrue' > doc/specs/padout
    chmod +x doc/specs/padout
    make ${M3_MAKEFLAGS} CROSS_COMPILE="${M3_CROSS_COMPILE}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
    # libtool is evil and breaks everything
    rm ${PKG_INSTALL_DIR}/lib/libpam.la
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
    # libtool is evil and breaks everything
    rm ${STAGING_DIR}/lib/libpam.la
}

. ${HELPERSDIR}/call_functions.sh
