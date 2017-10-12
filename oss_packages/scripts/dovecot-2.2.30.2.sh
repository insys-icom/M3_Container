#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="dovecot-2.2.30.2"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# https://dovecot.org/releases/2.2/dovecot-2.2.30.2.tar.gz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="44a8f904ff1086d2cc7fa99e202f4a7d"



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
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -lssl -lcrypto"

    export RPCGEN=__disable_RPCGEN_rquota
    export i_cv_posix_fallocate_works=yes
    export i_cv_signed_size_t=no
    export i_cv_signed_time_t=yes
    export i_cv_gmtime_max_time_t=40
    export i_cv_mmap_plays_with_write=yes
    export i_cv_fd_passing=yes
    export i_cv_c99_vsnprintf=yes
    export lib_cv_va_copy=yes
    export lib_cv___va_copy=yes
    export lib_cv_va_val_copy=no
    export i_cv_epoll_works=yes
    export i_cv_inotify_works=yes

    ./configure --target="${M3_TARGET}" --host="${M3_TARGET}" --prefix="" --with-sqlite --with-ssl=openssl -without-lzma --disable-rpath --with-pam --with-zlib --with-bzlib --with-libcap
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
