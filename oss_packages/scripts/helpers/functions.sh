#!/bin/sh

[ -n "${FUNCTIONS_INCLUDED}" ] && return

FUNCTIONS_INCLUDED=1

# download the source file
download()
{
    [ "${PKG_DOWNLOAD}" = "none" ] && return

    if [ ! -e "${DOWNLOADS_DIR}" ]; then
        mkdir -p "${DOWNLOADS_DIR}"
    fi

    if [ "${PKG_DOWNLOAD}" = "none" ]; then
        echo "\$PKG_DOWNLOAD is set to none, skipping download"
        return
    elif [ -z "$PKG_ARCHIVE_FILE" ]; then
        echo "\$PKG_ARCHIVE_FILE is empty, nothing to download"
        return
    elif [ -e "${PKG_ARCHIVE}" ] ; then
        # check the size of the file is not zero
        SIZE=$(stat -c%s ${PKG_ARCHIVE})
        if ! [ "${SIZE}" = "0" ] ; then
            echo "downloadfile \"${PKG_ARCHIVE}\" already exists"
            return
        fi
    elif [ -z "$PKG_DOWNLOAD" ]; then
        echo "\$PKG_DOWNLOAD is empty, cannot download"
        return
    fi
    echo "downloading to ${PKG_ARCHIVE}"
    wget -4 "${PKG_DOWNLOAD}" -O "${PKG_ARCHIVE}" -o /dev/null
    ret=$?
    if [ $ret -ne 0 ] ; then
        exit_failure "Failed to download ${PKG_DOWNLOAD}"
    fi
}

# check sha256 or (obsolete) md5 sum of a file
# $1 path to the file
# $2 given checksum to compare with
checksum()
{
    GIVEN_SUM="$2"
    len="${#GIVEN_SUM}"
    if [ "${len}" -eq "32" ] ; then
        CALC_SUM=$(md5sum $1 | cut -c -32)
        [ "${CALC_SUM}" = "${GIVEN_SUM}" ] && return 0
    else
        CALC_SUM=$(sha256sum $1 | cut -c -64)
        [ "${CALC_SUM}" = "${GIVEN_SUM}" ] && return 0
    fi

    echo "Checksum is ${CALC_SUM} but should be $2"
    return 1
}

# check source file in dl directory
check_source()
{
    # checksum test
    if [ -z "$PKG_ARCHIVE" -o -z "$PKG_ARCHIVE_FILE" ]; then
        echo "\$PKG_ARCHIVE/\$PKG_ARCHIVE_FILE is empty, skipping check_source()"
        return
    elif [ "${PKG_CHECKSUM}" = "none" ]; then
        echo "\$PKG_CHECKSUM is set to none, ignoring checksum"
        return
    elif [ -z "${PKG_CHECKSUM}" ]; then
        exit_failure "\$PKG_CHECKSUM is not set, ignoring checksum"
    else
        checksum ${PKG_ARCHIVE} ${PKG_CHECKSUM}
        ret=$?
        if [ $ret -ne 0 ]; then
            exit_failure "Checksum is incorrect"
        else
            echo "Checksum correct"
        fi
    fi
}

# check dependencies of project
check_deps()
{
    true
}

# replace project files with the local ones
copy_overlay()
{
    if [ -d "${PKG_SRC_DIR}" ] ; then
        for SFILE in $(find "${PKG_SRC_DIR}" -type f) ; do
            WFILE=$(echo ${SFILE} | sed "s#${SOURCES_DIR}#${BUILD_DIR}#")
            WDIR=$(dirname "${WFILE}")
            [ -d "${WDIR}" ] || mkdir -p "${WDIR}"
            rm -f "${WFILE}"
            cp -a "${SFILE}" "${WFILE}"
        done
    else
        true
    fi
}

# delete package build directory (under working)
del_working()
{
    rm -rf "${PKG_BUILD_DIR}" || exit_failure "Failed to delete {PKG_BUILD_DIR}"
}

# extract the project sources into working directory
unpack()
{
    ! [ -e "${PKG_BUILD_DIR}" ] && mkdir -p "${PKG_BUILD_DIR}"
    ! [ -e "${TARGET_DIR}" ] && mkdir -p "${TARGET_DIR}"

    if [ ! "${PKG_ARCHIVE_FILE}" = "none" ]; then
        if [ "${PKG_ARCHIVE##*.}" = "zip" ]; then
            unzip -d "${BUILD_DIR}" "${PKG_ARCHIVE}" || exit_failure "Unable to extract ${PKG_ARCHIVE}"
            [ -d "${PKG_BUILD_DIR}" ] || exit_failure "${PKG_BUILD_DIR} was not found in archive"
        fi
        if [ "${PKG_ARCHIVE##*.}" = "tar" -o \
             "${PKG_ARCHIVE##*.}" = "tgz" -o \
             "${PKG_ARCHIVE##*.}" = "gz" -o \
             "${PKG_ARCHIVE##*.}" = "xz" -o \
             "${PKG_ARCHIVE##*.}" = "bz2" -o \
             "${PKG_ARCHIVE##*.}" = "lz" -o \
             "${PKG_ARCHIVE##*.}" = "xz" ]; then
            tar -C "${BUILD_DIR}" -xf "${PKG_ARCHIVE}" || exit_failure "Unable to extract ${PKG_ARCHIVE}"
            [ -d "${PKG_BUILD_DIR}" ] || exit_failure "${PKG_BUILD_DIR} was not found in archive"
        fi
    fi

    copy_overlay
}

# remove installed project files from the staging area
uninstall_staging()
{
    [ -d "${PKG_INSTALL_DIR}" ] || return 1
    find "${PKG_INSTALL_DIR}" -type f | sed "s|^${PKG_INSTALL_DIR}|${STAGING_DIR}|" | xargs rm -vf
}

# print error message and exit
exit_failure()
{
    echo $*
    exit 1
}

# do all steps building a project
all()
{
    download
    check_source
    check_deps
    del_working
    unpack
    configure
    compile
    install_staging
}
