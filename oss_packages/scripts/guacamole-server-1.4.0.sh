#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="guacamole-server-1.4.0"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
#PKG_DOWNLOAD="https://apache.org/dyn/closer.lua/guacamole/1.4.0/source/${PKG_ARCHIVE_FILE}?action=download"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="b17c6152e96af0488ca4c0608e5ec3ae"



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
    ac_cv_lib_png_png_write_png=yes \
    ac_cv_lib_cairo_cairo_create=yes \
    ac_cv_lib_uuid_uuid_make=yes \
    ac_cv_lib_vncclient_rfbInitClient=yes \
    ac_cv_lib_ssl_SSL_CTX_new=yes \
    ./configure \
        CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}" \
        CPPFLAGS="-I${STAGING_INCLUDE}" \
        LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB} -ldl -lssl" \
        VNC_LIBS="${STAGING_LIB}" \
        PKG_CONFIG_LIBDIR="${STAGING_LIB}" \
        LIBS="-Wl,--no-as-neede -ldl" \
        --disable-kubernetes \
        --disable-guacd \
        --disable-guacenc \
        --disable-guaclog \
        --target="${M3_TARGET}" \
        --host="${M3_TARGET}" \
        --prefix="" || exit_failure "failed to configure ${PKG_DIR}"
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
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
