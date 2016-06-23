#! /bin/sh

# download link for the sources to be stored in dl directory
PKG_DOWNLOAD_DATA="https://www.iana.org/time-zones/repository/releases/tzdata2016e.tar.gz"
PKG_DOWNLOAD_CODE="https://www.iana.org/time-zones/repository/releases/tzcode2016e.tar.gz"

# md5 checksum of archive in dl directory
PKG_CHECKSUM_DATA="43f9f929a8baf0dd2f17efaea02c2d2a"
PKG_CHECKSUM_CODE="6e6d3f0046a9383aafba8c2e0708a3a3"

# name of directory after extracting the archive in working directory
PKG_DIR="timezone2016e"

# name of the archive in dl directory
PKG_ARCHIVE_DATA_FILE="tzdata2016e.tar.gz"
PKG_ARCHIVE_CODE_FILE="tzcode2016e.tar.gz"

SCRIPTSDIR="$(dirname $0)"
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR="$(realpath ${SCRIPTSDIR}/../..)"

. ${TOPDIR}/scripts/common_settings.sh
. ${HELPERSDIR}/functions.sh

PKG_ARCHIVE_DATA="${DOWNLOADS_DIR}/${PKG_ARCHIVE_DATA_FILE}"
PKG_ARCHIVE_CODE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_CODE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

# download the sources with wget, if the file is not already stored
download_part()
{
    echo "${1}"
    if [ -e "${1}" ] ; then
        # check the size of the file is not zero
        SIZE="$(stat -c%s ${1})"
        if ! [ "${SIZE}" = "0" ] ; then
            echo ""
            echo "The sources \"${2}\" are already stored, no need to download them again"
            echo ""
            return
        fi
    fi

    wget "${2}" -O "${1}"
    if ! [ "$?" == "0" ] ; then
        mkdir -p "${DOWNLOADS_DIR}"
        echo "Failed to download ${2}"
        echo ""
        echo "Check connection to internet or download and store the file manually as \"${2}\""
        exit 1
    fi
}

download()
{    
    download_part "${PKG_ARCHIVE_DATA}" "${PKG_DOWNLOAD_DATA}"
    download_part "${PKG_ARCHIVE_CODE}" "${PKG_DOWNLOAD_CODE}"
}

check_source()
{ 
    check_md5 ${PKG_ARCHIVE_DATA} ${PKG_CHECKSUM_DATA} || exit_failure "Checksum failure"
    check_md5 ${PKG_ARCHIVE_CODE} ${PKG_CHECKSUM_CODE} || exit_failure "Checksum failure"
}

unpack()
{
    mkdir ${PKG_BUILD_DIR} 2> /dev/null
    tar -C ${PKG_BUILD_DIR} -xf ${PKG_ARCHIVE_DATA} || exit_failure "unable to extract ${PKG_ARCHIVE}"
    tar -C ${PKG_BUILD_DIR} -xf ${PKG_ARCHIVE_CODE} || exit_failure "unable to extract ${PKG_ARCHIVE}"
    copy_overlay
}

configure()
{
    true
}

compile()
{
    copy_overlay
    cd "${PKG_BUILD_DIR}"
    #export CROSS_COMPILE="${M3_CROSS_COMPILE}"
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    cp -r "${PKG_INSTALL_DIR}/usr/local/etc/zoneinfo" "${STAGING_DIR}/usr/share"
}

. ${HELPERSDIR}/call_functions.sh
