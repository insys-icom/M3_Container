#!/bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://nodejs.org/dist/v7.4.0/node-v7.4.0.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="9732aba61759bc97d2bb2e7d82453f83"

# name of directory after extracting the archive in working directory
PKG_DIR="node-v7.4.0"

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
    #export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    export CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"

    #Define our target device
    export TARGET_ARCH="-march=armv7-a"
    export TARGET_TUNE="-mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp -mthumb-interwork -mno-thumb"

    #Define the cross compilators on your system
    export AR="armv7a-hardfloat-linux-gnueabi-ar"
    export CC="armv7a-hardfloat-linux-gnueabi-gcc"
    export CXX="armv7a-hardfloat-linux-gnueabi-g++"
    export LINK="armv7a-hardfloat-linux-gnueabi-g++"
    export CPP="armv7a-hardfloat-linux-gnueabi-gcc -E"
    export LD="armv7a-hardfloat-linux-gnueabi-ld"
    export AS="armv7a-hardfloat-linux-gnueabi-as"
    export CCLD="armv7a-hardfloat-linux-gnueabi-gcc ${TARGET_ARCH} ${TARGET_TUNE}"
    export NM="armv7a-hardfloat-linux-gnueabi-nm"
    export STRIP="armv7a-hardfloat-linux-gnueabi-strip"
    export OBJCOPY="armv7a-hardfloat-linux-gnueabi-objcopy"
    export RANLIB="armv7a-hardfloat-linux-gnueabi-ranlib"
    export F77="armv7a-hardfloat-linux-gnueabi-g77 ${TARGET_ARCH} ${TARGET_TUNE}"

    export AR_host="ar"
    export CC_host="gcc"
    export CXX_host="g++"
    export LINK_host="g++"
    export CPP_host="gcc -E"
    export LD_host="ld"
    export AS_host="as"
    export CCLD_host="gcc"
    export NM_host="nm"
    export STRIP_host="strip"
    export OBJCOPY_host="objcopy"
    export RANLIB_host="ranlib"
    export F77_host="g77"

    unset LIBC

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
    make "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    make -i DESTDIR="${STAGING_DIR}" install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
