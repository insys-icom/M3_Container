#!/bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://github.com/open62541/open62541/archive/0.2-rc2.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="cf45f8793e97907de671f5f86dadcd29"

# name of directory after extracting the archive in working directory
PKG_DIR="open62541-0.2-rc2"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

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
    cd "${PKG_BUILD_DIR}"
    
    export CFLAGS="${M3_CFLAGS}"
    export LDFLAGS="${M3_LDFLAGS}"
    export CROSS_COMPILE=${M3_CROSS_COMPILE}
    
	cmake -DCMAKE_C_COMPILER=${CROSS_COMPILE}gcc -DCMAKE_C_FLAGS="$(CFLAGS)" -DCMAKE_CXX_COMPILER=${CROSS_COMPILE}g++ -DCMAKE_CXX_FLAGS="$(CFLAGS)" -DCMAKE_SHARED_LINKER_FLAGS="$(LDFLAGS)" \
		  -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Debug -DUA_ENABLE_AMALGAMATION=ON -DCMAKE_INSTALL_PREFIX="${STAGING_DIR}"
}

compile()
{
    cd "${PKG_BUILD_DIR}"
    make -j ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
