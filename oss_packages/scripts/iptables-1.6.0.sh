#! /bin/sh

# download link for the sources to be stored in dl directory
#PKG_DOWNLOAD="http://www.netfilter.org/projects/iptables/files/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="http://www.netfilter.org/projects/iptables/files/iptables-1.6.0.tar.bz2"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="27ba3451cb622467fc9267a176f19a31"

# name of directory after extracting the archive in working directory
PKG_DIR="iptables-1.6.0"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.bz2"


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
    export CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    ./configure --target=${M3_TARGET} --host=${M3_TARGET} --enable-static --disable-shared --with-kbuild=${BUILD_DIR}/linux-${ROOTFS_KERNEL_VERSION}/build/system --with-ksource=${BUILD_DIR}/linux-${ROOTFS_KERNEL_VERSION} --disable-nftables --prefix=""
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
