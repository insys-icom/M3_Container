#!/bin/sh

# use all CPU cores of host
export CPU_THREADS=$(grep processor /proc/cpuinfo | wc -l)

if [ "${ARCH}" == "amd64" ] ; then
    M3_TARGET="x86_64-pc-linux-gnu"
    M3_CFLAGS="-Os -flto=${CPU_THREADS} -fuse-linker-plugin -ffunction-sections -fdata-sections -Wno-nonnull-compare"
    M3_LDFLAGS="-Wl,--as-needed -Os -flto=${CPU_THREADS} -fuse-linker-plugin -Wl,--gc-sections -Wno-nonnull-compare"

    GCC_VERSION=$(ls /usr/lib/gcc/${M3_TARGET} | sort | tail -n 1)
    GCC_LIB_DIR="/usr/lib/gcc/${M3_TARGET}/${GCC_VERSION}/"
    SYSROOT_DIR="/lib64"
    PATH="$PATH:/usr/${M3_TARGET}/gcc-bin/${GCC_VERSION}"

    # prefere self compiled libs in rootfs_staging instead of SDK native libs
    LD_LIBRARY_PATH="${STAGING_LIB}"
elif [ "${ARCH}" == "aarch64" ] ; then
    M3_TARGET="aarch64-unknown-linux-gnu"
    M3_CFLAGS="-Os -flto=${CPU_THREADS} -fuse-linker-plugin -ffunction-sections -fdata-sections"
    M3_LDFLAGS="-Wl,--as-needed -Os -flto=${CPU_THREADS} -fuse-linker-plugin -Wl,--gc-sections"

    GCC_VERSION=$(ls /usr/lib/gcc/${M3_TARGET} | sort | tail -n 1)
    GCC_LIB_DIR="/usr/lib/gcc/${M3_TARGET}/${GCC_VERSION}/"
    SYSROOT_DIR="/usr/${M3_TARGET}"
    PATH="$PATH:/usr/i686-pc-linux-gnu/${M3_TARGET}/gcc-bin/${GCC_VERSION}"
else
    ARCH=armv7
    M3_TARGET="armv7a-hardfloat-linux-gnueabi"
    M3_CFLAGS="-Os -mthumb -march=armv7-a -mtune=cortex-a8 -flto=${CPU_THREADS} -fuse-linker-plugin -ffunction-sections -fdata-sections"
    M3_LDFLAGS="-Wl,--as-needed -Os -mthumb -march=armv7-a -mtune=cortex-a8 -flto=${CPU_THREADS} -fuse-linker-plugin -Wl,--gc-sections"

    GCC_VERSION=$(ls /usr/lib/gcc/${M3_TARGET} | sort | tail -n 1)
    GCC_LIB_DIR="/usr/lib/gcc/${M3_TARGET}/${GCC_VERSION}/"
    SYSROOT_DIR="/usr/${M3_TARGET}"
    PATH="$PATH:/usr/i686-pc-linux-gnu/${M3_TARGET}/gcc-bin/${GCC_VERSION}"
fi

export AR=$(which ${M3_TARGET}-gcc-ar)
export NM=$(which ${M3_TARGET}-gcc-nm)
export RANLIB=$(which ${M3_TARGET}-gcc-ranlib)

M3_CROSS_COMPILE="${M3_TARGET}-"
M3_MAKEFLAGS="-j${CPU_THREADS}"

OSS_PACKAGES_DIR="${TOPDIR}/oss_packages"
OSS_PACKAGES_SCRIPTS="${OSS_PACKAGES_DIR}/scripts"
DOWNLOADS_DIR="${OSS_PACKAGES_DIR}/dl"
SOURCES_DIR="${OSS_PACKAGES_DIR}/src"
CLOSED_PACKAGES_DIR="${TOPDIR}/closed_packages"
BUILD_DIR="${TOPDIR}/working/${ARCH}"
STAGING_DIR="${TOPDIR}/rootfs_staging/${ARCH}"
STAGING_INCLUDE="${STAGING_DIR}/include"
STAGING_LIB="${STAGING_DIR}/lib"
FS_TARGET_DIR="${BUILD_DIR}/rootfs_target"
TARGET_DIR="${FS_TARGET_DIR}/rootfs"
SKELETON_DIR="${TOPDIR}/rootfs_skeleton"
OUTPUT_DIR="${TOPDIR}/images/${ARCH}"
UPDATE_TAR="${BUILD_DIR}/update/update.tar"

exit_failure()
{
    echo $*
    exit 1
}
