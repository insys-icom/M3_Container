#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="timezone2018i"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_DATA_FILE="tzdata2018i.tar.gz"
PKG_ARCHIVE_CODE_FILE="tzcode2018i.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD_DATA="https://www.iana.org/time-zones/repository/releases/${PKG_ARCHIVE_DATA_FILE}"
# PKG_DOWNLOAD_CODE="https://www.iana.org/time-zones/repository/releases/${PKG_ARCHIVE_CODE_FILE}"
PKG_DOWNLOAD_DATA="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_DATA_FILE}"
PKG_DOWNLOAD_CODE="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_CODE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM_DATA="b3f0a1a789480a036e58466cd0702477"
PKG_CHECKSUM_CODE="6a6d98be8fa2fa3485e25343e79188b4"


SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE_DATA="${DOWNLOADS_DIR}/${PKG_ARCHIVE_DATA_FILE}"
PKG_ARCHIVE_CODE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_CODE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

download()
{
    local data_fail=0
    local code_fail=0

    if [ -e "${PKG_ARCHIVE_DATA}" ]; then
        # check the size of the file is not zero
        SIZE=$(stat -c%s ${PKG_ARCHIVE_DATA})
        if ! [ "${SIZE}" = "0" ] ; then
            echo "downloadfile \"${PKG_ARCHIVE_DATA}\" already exists"
        else
            echo "source \"${PKG_ARCHIVE_DATA}\" has 0Bytes"
            data_fail=1
        fi
    else
        echo "downloading to ${PKG_ARCHIVE_DATA}"
        wget -4 "${PKG_DOWNLOAD_DATA}" -O "${PKG_ARCHIVE_DATA}" -o /dev/null
        ret=$?
        if [ $ret -ne 0 ] ; then
            echo "Failed to download ${PKG_DOWNLOAD_DATA}"
            data_fail=1
        fi
    fi

    if [ -e "${PKG_ARCHIVE_CODE}" ]; then
        # check the size of the file is not zero
        SIZE=$(stat -c%s ${PKG_ARCHIVE_CODE})
        if ! [ "${SIZE}" = "0" ] ; then
            echo "downloadfile \"${PKG_ARCHIVE_CODE}\" already exists"
        else
            echo "source \"${PKG_ARCHIVE_CODE}\" has 0Bytes"
            code_fail=1
        fi
    else
        echo "downloading to ${PKG_ARCHIVE_CODE}"
        wget -4 "${PKG_DOWNLOAD_CODE}" -O "${PKG_ARCHIVE_CODE}" -o /dev/null
        ret=$?
        if [ $ret -ne 0 ] ; then
            echo "Failed to download ${PKG_DOWNLOAD_CODE}"
            code_fail=1
        fi
    fi

    if [ $data_fail -eq 1 -o $code_fail -eq 1 ]; then
        exit_failure "Download failed"
    fi
}

check_source()
{
    local data_fail=0
    local code_fail=0

    # MD5SUM test 1
    check_md5 ${PKG_ARCHIVE_DATA} ${PKG_CHECKSUM_DATA}
    ret=$?
    if [ $ret -ne 0 ]; then
      echo "md5sum check of ${PKG_ARCHIVE_DATA_FILE} failed"
      data_fail=1
    else
      echo "md5sum check of ${PKG_ARCHIVE_DATA_FILE} OK"
    fi
    # Optional archive test 1, can be commented out if desired
    if [ "${PKG_ARCHIVE_DATA##*.}" = "zip" ]; then
        unzip -t ${PKG_ARCHIVE_DATA} > /dev/null
        ret=$?
    else
        tar -tf ${PKG_ARCHIVE_DATA} > /dev/null
        ret=$?
    fi

    if [ $ret -ne 0 ]; then
        echo "archive check of ${PKG_ARCHIVE_DATA_FILE} failed"
        data_fail=1
    else
        echo "archive check of ${PKG_ARCHIVE_DATA_FILE} OK"
    fi

   # MD5SUM test 2
    check_md5 ${PKG_ARCHIVE_CODE} ${PKG_CHECKSUM_CODE}
    ret=$?
    if [ $ret -ne 0 ]; then
      echo "md5sum check of ${PKG_ARCHIVE_CODE_FILE} failed"
      code_fail=1
    else
      echo "md5sum check of ${PKG_ARCHIVE_CODE_FILE} OK"
    fi
    # Optional archive test 2, can be commented out if desired
    if [ "${PKG_ARCHIVE_CODE##*.}" = "zip" ]; then
        unzip -t ${PKG_ARCHIVE_CODE} > /dev/null
        ret=$?
    else
        tar -tf ${PKG_ARCHIVE_CODE} > /dev/null
        ret=$?
    fi

    if [ $ret -ne 0 ]; then
        echo "archive check of ${PKG_ARCHIVE_CODE_FILE} failed"
        code_fail=1
    else
        echo "archive check of ${PKG_ARCHIVE_CODE_FILE} OK"
    fi

    if [ $data_fail -eq 1 -o $code_fail -eq 1 ]; then
        exit_failure "check_source failed"
    fi
 }

unpack()
{
    mkdir ${PKG_BUILD_DIR} 2> /dev/null
    tar -C ${PKG_BUILD_DIR} -xf ${PKG_ARCHIVE_DATA} || exit_failure "unable to extract ${PKG_ARCHIVE_DATA}"
    tar -C ${PKG_BUILD_DIR} -xf ${PKG_ARCHIVE_CODE} || exit_failure "unable to extract ${PKG_ARCHIVE_CODE}"
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
    make ${M3_MAKEFLAGS} || exit_failure "failed to build ${PKG_DIR}"
    make DESTDIR="${PKG_INSTALL_DIR}" install || exit_failure "failed to install ${PKG_DIR} to ${PKG_INSTALL_DIR}"
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    test -d "${STAGING_DIR}/usr/share/" || mkdir -p "${STAGING_DIR}/usr/share/"
    cp -r "${PKG_INSTALL_DIR}/usr/share/zoneinfo/" "${STAGING_DIR}/usr/share/" || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"
}

. ${HELPERSDIR}/call_functions.sh
