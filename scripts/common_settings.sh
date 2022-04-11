#!/bin/sh
# use all CPU cores of host
export CPU_THREADS=$(grep processor /proc/cpuinfo | wc -l)

# create optimized build
M3_CFLAGS="-Os -mthumb -march=armv7-a -mtune=cortex-a8 -flto=${CPU_THREADS} -fuse-linker-plugin -ffunction-sections -fdata-sections"
M3_LDFLAGS="-Wl,--as-needed -Os -mthumb -march=armv7-a -mtune=cortex-a8 -flto=${CPU_THREADS} -fuse-linker-plugin -Wl,--gc-sections"

# build with sanitizer
# M3_CFLAGS="-Og -ggdb -mthumb -march=armv7-a -mtune=cortex-a8 -fno-common -fsanitize=address"
# M3_LDFLAGS="-Wl,--as-needed -Og -ggdb -mthumb -march=armv7-a -mtune=cortex-a8 -fno-common -lstdc++ -fsanitize=address"
#  -fsanitize=undefined is a bit too much

# build for gdb / valgrind
# M3_CFLAGS="-Og -ggdb -mthumb -march=armv7-a -mtune=cortex-a8"
# M3_LDFLAGS="-Wl,--as-needed -Og -ggdb -mthumb -march=armv7-a -mtune=cortex-a8"

M3_TARGET=armv7a-hardfloat-linux-gnueabi
M3_CROSS_COMPILE=${M3_TARGET}-

export AR=$(which ${M3_CROSS_COMPILE}gcc-ar)
export NM=$(which ${M3_CROSS_COMPILE}gcc-nm)
export RANLIB=$(which ${M3_CROSS_COMPILE}gcc-ranlib)

M3_MAKEFLAGS="-j${CPU_THREADS}"

OSS_PACKAGES_DIR="${TOPDIR}/oss_packages"
OSS_PACKAGES_SCRIPTS="${OSS_PACKAGES_DIR}/scripts"
DOWNLOADS_DIR="${OSS_PACKAGES_DIR}/dl"
SOURCES_DIR="${OSS_PACKAGES_DIR}/src"
CLOSED_PACKAGES_DIR="${TOPDIR}/closed_packages"
KEYS_DIR="${TOPDIR}/../Container_Sepia/keys"

BUILD_DIR=$(realpath "${TOPDIR}/working/")
STAGING_DIR="${TOPDIR}/rootfs_staging"
STAGING_INCLUDE="${STAGING_DIR}/include"
STAGING_LIB="${STAGING_DIR}/lib"

FS_TARGET_DIR=$(realpath "${TOPDIR}/working/rootfs_target")
TARGET_DIR="${FS_TARGET_DIR}/rootfs"
SKELETON_DIR=$(realpath "${TOPDIR}/rootfs_skeleton")

# use the latest available compiler version
GCC_VERSION=$(ls /usr/lib/gcc/armv7a-hardfloat-linux-gnueabi | sort  | tail -n 1)
GCC_LIB_DIR="/usr/lib/gcc/armv7a-hardfloat-linux-gnueabi/${GCC_VERSION}/"
SYSROOT_DIR="/usr/armv7a-hardfloat-linux-gnueabi"
PATH="$PATH:/usr/i686-pc-linux-gnu/armv7a-hardfloat-linux-gnueabi/gcc-bin/${GCC_VERSION}"

OUTPUT_DIR=$(realpath "${TOPDIR}/images")

UPDATE_TAR="${BUILD_DIR}/update/update.tar"
