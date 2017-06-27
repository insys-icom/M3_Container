#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="org.eclipse.4diac.forte-1.8.4"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
# http://git.eclipse.org/c/4diac/org.eclipse.4diac.forte.git/snapshot/org.eclipse.4diac.forte-1.8.4.tar.gz
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="83b106d0b270f958ad58151706dda496"



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

    echo "----------------------------------------------------------------------------"
    echo " Automatically set up development environment for POSIX-platform"
    echo "----------------------------------------------------------------------------"
    echo ""
    echo " Includes 64bit-datatypes, float-datatypes, Ethernet-Interface,"
    echo " ASN1-encoding, ..."
    echo ""
    echo "----------------------------------------------------------------------------"

    export forte_bin_dir="bin/posix"

    if [ ! -d "$forte_bin_dir" ] ; then
        mkdir -p "$forte_bin_dir"
    fi

    if [ -d "$forte_bin_dir" ] ; then
        cd "${PKG_BUILD_DIR}/bin/posix"
        # use old libmodbus 3.0.6
        cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=DEBUG -DFORTE_ARCHITECTURE=Posix -DFORTE_LOGLEVEL=LOGDEBUG -DFORTE_TESTS=OFF \
        -DCMAKE_AR=/usr/bin/armv7a-hardfloat-linux-gnueabi-ar -DCMAKE_CXX_COMPILER=/usr/bin/armv7a-hardfloat-linux-gnueabi-g++ \
        -DCMAKE_CXX_FLAGS="-std=gnu++14 -w -s -I${PKG_BUILD_DIR}/../libmodbus-3.0.6/install/include -L${PKG_BUILD_DIR}/../libmodbus-3.0.6/install -I${STAGING_INCLUDE} -L${STAGING_LIB}" \
        -DCMAKE_C_COMPILER=/usr/bin/armv7a-hardfloat-linux-gnueabi-gcc \
        -DCMAKE_LINKER=/usr/bin/armv7a-hardfloat-linux-gnueabi-ld -DCMAKE_NM=/usr/bin/armv7a-hardfloat-linux-gnueabi-nm -DCMAKE_OBJCOPY=/usr/bin/armv7a-hardfloat-linux-gnueabi-objcopy \
        -DCMAKE_OBJDUMP=/usr/bin/armv7a-hardfloat-linux-gnueabi-objdump -DCMAKE_RANLIB=/usr/bin/armv7a-hardfloat-linux-gnueabi-ranlib \
        -DCMAKE_STRIP=/usr/bin/armv7a-hardfloat-linux-gnueabi-strip \
        -DFORTE_COM_ETH=ON -DFORTE_COM_FBDK=ON -DFORTE_COM_LOCAL=ON -DFORTE_COM_MODBUS=ON -DFORTE_COM_PAHOMQTT=ON -DFORTE_COM_RAW=ON -DFORTE_COM_SER=ON \
        -DFORTE_COM_PAHOMQTT_DIR="${STAGING_LIB}" \
        -DFORTE_MODULE_CONVERT=ON -DFORTE_MODULE_I2C-Dev=ON -DFORTE_MODULE_IEC61131=ON -DFORTE_MODULE_INSYS_Functionblocks=ON -DFORTE_MODULE_RECONFIGURATION=ON -DFORTE_MODULE_UTILS=ON \
        -DCMAKE_INSTALL_PREFIX="${STAGING_DIR}" ../../
        #OPC UA is available at version 1.9
        #-DFORTE_COM_OPC_UA=ON -DFORTE_COM_OPC_UCA_LIB=libopen62541.so -DFORTE_COM_OPC_UCA_DIR=${OPC_UA_DIR}
    else
        echo "unable to create ${forte_bin_dir}"
        exit 1
    fi

    copy_overlay
}

compile()
{
    cd "${PKG_BUILD_DIR}/bin/posix"
    make -j1 "${M3_MAKEFLAGS}" || exit_failure "failed to build ${PKG_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}/bin/posix"
    make install || exit_failure "failed to install ${PKG_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
