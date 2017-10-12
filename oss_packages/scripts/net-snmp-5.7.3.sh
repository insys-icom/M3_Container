#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="net-snmp-5.7.3"

# name of the archive in dl directory
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory
PKG_CHECKSUM="d4a3459e1577d0efa8d96ca70a885e53"



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
    export LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}"
    # The configure script always prompts for one enter, this is done by the yes tool
    # set the prefix to the package install dir (in working) as the "make DESTDIR=..." would install in the pkg_install_dir appended by the location of the configure file (default of the configure)
    yes | ./configure --target=${M3_TARGET} --host=${M3_TARGET} --prefix="${PKG_INSTALL_DIR}" --enable-mini-agent --disable-manuals --disable-scripts --disable-mibs --disable-mib-loading --disable-embedded-perl --disable-perl-cc-checks --with-transports="UDP UDPIPv6 Callback" --with-out-transports="Alias TCP TCPIPv6 Unix AAL5PVC IPX" --with-out-mib-modules="mibII agent_mibs agentx notification target utilities disman/event disman/schedule host" --with-mib-modules="ucd_snmp snmpv3mibs ip-mib/ipv4InterfaceTable ip-mib/ipv6InterfaceTable" --without-kmem-usage --with-endianness=little --without-rpm --with-default-snmp-version="3" --disable-snmpv1 --enable-shared --enable-ipv6 --disable-debugging --disable-deprecated --disable-set-support --disable-snmptrapd-subagent --without-perl-modules --disable-as-needed --with-sys-contact="" --with-sys-location="" --with-logfile="none"   --with-persistent-directory="/var" --with-out-security-modules="ksm tsm"
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    # Copy the needed files manually, as the configure script would mess up the paths if the prefix is not given or empty
    cp -r ${PKG_INSTALL_DIR}/include/* ${STAGING_DIR}/include
    cp -P ${PKG_INSTALL_DIR}/lib/libnetsnmp.so* ${STAGING_DIR}/lib/
}

. ${HELPERSDIR}/call_functions.sh
