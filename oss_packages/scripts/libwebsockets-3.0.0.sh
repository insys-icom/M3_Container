#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="libwebsockets-3.0.0"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://github.com/warmcat/libwebsockets/archive/v3.0.0.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="2a78c8c49bbbfe67c24637398d989958"



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
    cmake \
        -DCMAKE_C_COMPILER=${M3_CROSS_COMPILE}gcc \
        -DCMAKE_C_FLAGS="${M3_CFLAGS} -fPIC -I${STAGING_INCLUDE} -L${STAGING_LIB}" \
        -DCMAKE_AR=${AR} \
        -DCMAKE_LINKER=${M3_CROSS_COMPILE}ld \
        -DCMAKE_STRIP=${M3_CROSS_COMPILE}strip \
        -DCMAKE_NM=${NM} \
        -DCMAKE_RANLIB=${RANLIB} \
        -DCMAKE_INSTALL_PREFIX="" \
        -DLWS_OPENSSL_INCLUDE_DIRS="${STAGING_INCLUDE}" \
        -DLWS_OPENSSL_LIBRARIES="${STAGING_LIB}/libssl.so;${STAGING_LIB}/libcrypto.so" \
        -DLWS_WITH_HTTP2=1 \
        -DLWS_IPV6=ON \
        -DLWS_UNIX_SOCK=ON \
        -DLWS_WITH_LEJP=ON \
        -DLWS_WITH_LEJP_CONF=ON \
        -DLWS_WITHOUT_TESTAPPS=OFF \
        -DLWS_WITHOUT_DAEMONIZE=ON \
        || exit_failure "failed to configure ${PKG_DIR}"
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
