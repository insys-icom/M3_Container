#!/bin/sh

. $(realpath $(dirname $0)/../scripts/common_settings.sh)
export CROSS_COMPILE="${M3_CROSS_COMPILE}"
export OPTIMIZE_CFLAGS="${M3_CFLAGS} -L${STAGING_LIB} -I${STAGING_INCLUDE}"
export OPTIMIZE_LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
export CC="${CROSS_COMPILE}gcc"
export LD="${CROSS_COMPILE}ld"
export STRIP="${CROSS_COMPILE}strip"

cd $(dirname $0)/hello_world

make clean
make all
make install
