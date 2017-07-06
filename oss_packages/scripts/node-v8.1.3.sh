#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="node-v8.1.3"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# https://nodejs.org/dist/v8.1.3/node-v8.1.3.tar.gz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="804f6e145292cb9ddc2e742db96fb553"



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
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    export TARGET_ARCH="-march=armv7-a"
    export TARGET_TUNE="-mtune=cortex-a8 -mfpu=neon -mfloat-abi=hardfp -mthumb-interwork -mno-thumb"
    export CC="armv7a-hardfloat-linux-gnueabi-gcc"
    export CXX="armv7a-hardfloat-linux-gnueabi-g++"
    export CPP="armv7a-hardfloat-linux-gnueabi-gcc -E"
    export LD="armv7a-hardfloat-linux-gnueabi-ld"
    export CC_host="gcc"
    export CXX_host="g++"

    ./configure --without-snapshot --prefix="/" --dest-cpu=arm --dest-os=linux --cross-compiling \
        --shared-openssl --shared-openssl-includes="${STAGING_INCLUDE}" --shared-openssl-libpath="${STAGING_LIB}" \
        --shared-zlib --shared-zlib-includes="${STAGING_INCLUDE}" --shared-zlib-libpath="${STAGING_LIB}" \
        --shared-http-parser --shared-http-parser-includes="${STAGING_INCLUDE}" --shared-http-parser-libpath="${STAGING_LIB}" \
        --shared-libuv --shared-libuv-includes="${STAGING_INCLUDE}" --shared-libuv-libpath="${STAGING_LIB}" \
        --shared-cares --shared-cares-includes="${STAGING_INCLUDE}" --shared-cares-libpath="${STAGING_LIB}"

    # do no link against not used libs for host compiler
    FILES="${FILES} ${PKG_BUILD_DIR}/out/deps/v8/src/mkpeephole.host.mk"
    FILES="${FILES} ${PKG_BUILD_DIR}/out/tools/icu/icupkg.host.mk"
    FILES="${FILES} ${PKG_BUILD_DIR}/out/tools/icu/iculslocs.host.mk"
    FILES="${FILES} ${PKG_BUILD_DIR}/out/tools/icu/genrb.host.mk"
    FILES="${FILES} ${PKG_BUILD_DIR}/out/tools/icu/genccode.host.mk"
    for FILE in ${FILES} ; do
        sed -i 's/-luv \\/\\/g' "${FILE}"
        sed -i 's/-lcares \\/\\/g' "${FILE}"
        sed -i 's/-lz \\/\\/g' "${FILE}"
        sed -i 's/-lhttp_parser \\/\\/g' "${FILE}"
        sed -i 's/-lcrypto \\/\\/g' "${FILE}"
        sed -i 's/-lssl \\/\\/g' "${FILE}"
        sed -i 's/-lssl//g' "${FILE}"
    done
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    unset CFLAGS
    unset LDFLAGS
    unset TARGET_ARCH
    unset TARGET_TUNE
    unset CC
    unset CXX
    unset CPP
    unset LD
    unset CC_host
    unset CXX_host

    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
