#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="talloc-2.1.11"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://www.samba.org/ftp/talloc/talloc-2.1.11.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="452596f904ca2b10322bdaabf147a721"



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
    cd "${PKG_BUILD_DIR}"

    echo -en '
Checking simple C program: OK
rpath library support: NO
-Wl,--version-script support: OK
Checking getconf LFS_CFLAGS: NO
Checking for large file support without additional flags: NO
Checking for -D_FILE_OFFSET_BITS=64: NO
Checking for -D_LARGE_FILES: OK
Checking uname sysname type: "m3sdk"
Checking uname machine type: "Linux"
Checking uname release type: "4.14.2"
Checking uname version type: "5"
Checking correct behavior of strtoll: OK
Checking for working strptime: OK
Checking for C99 vsnprintf: OK
Checking for HAVE_SHARED_MMAP: OK
Checking for HAVE_MREMAP: OK
Checking for HAVE_INCOHERENT_MMAP: OK
Checking for HAVE_SECURE_MKSTEMP: OK
Checking for HAVE_IFACE_GETIFADDRS: OK
Checking for HAVE_IFACE_IFCONF: OK
Checking for HAVE_IFACE_IFREQ: OK
' > answer.txt

    CC="${M3_CROSS_COMPILE}gcc" \
    CPP="${M3_CROSS_COMPILE}gcc" \
    CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
    LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
    PREFIX="" \
        ./configure \
            --cross-compile \
            --cross-answers=answer.txt || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cp "${PKG_BUILD_DIR}/install/usr/local/include/talloc.h" "${STAGING_INCLUDE}"
    cp "${PKG_BUILD_DIR}/install/usr/local/lib/libtalloc.so"* "${STAGING_LIB}"
}

uninstall_staging()
{
    rm -vf "${STAGING_INCLUDE}/talloc.h"
    rm -vf "${STAGING_LIB}/libtalloc.so"*
}

. ${HELPERSDIR}/call_functions.sh
