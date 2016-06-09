#! /bin/sh

[ -n "${FUNCTIONS_INCLUDED}" ] && return

FUNCTIONS_INCLUDED=1

# download the sources with wget, if the file is not already stored
download()
{
    echo ${PKG_ARCHIVE}
    if [ -e "${PKG_ARCHIVE}" ] ; then
        # check the size of the file is not zero
        SIZE="$(stat -c%s ${PKG_ARCHIVE})"
        if ! [ "${SIZE}" = "0" ] ; then
            echo ""
            echo "The sources \"${PKG_DOWNLOAD}\" are already stored, no need to download them again"
            echo ""
            return
        fi
    fi

    wget "${PKG_DOWNLOAD}" -O "${PKG_ARCHIVE}"
    if ! [ "$?" == "0" ] ; then
        echo "Failed to download ${PKG_DOWNLOAD}"
    fi
}

# check md5 sum of a file
# $1 path to the file
# $2 md5sum to compare with
check_md5()
{
    CALC_SUM=$(md5sum $1 | cut -c -32)
    [ "$2" = "${CALC_SUM}" ]
    return $?
}

# check if source files is stored in dl directory
check_source()
{
    [ "${PKG_CHECKSUM}" = "none" ] && return
    check_md5 ${PKG_ARCHIVE} ${PKG_CHECKSUM} || exit_failure "Checksum failure"
}

# check dependencies of project
check_deps()
{
    true
}

# replace projects files with the local ones
copy_overlay()
{
    if [ -d "${PKG_SRC_DIR}" ] ; then
        for SFILE in $(find "${PKG_SRC_DIR}" -type f) ; do
            WFILE=$(echo ${SFILE} | sed "s#${SOURCES_DIR}#${BUILD_DIR}#")
            WDIR=$(dirname "${WFILE}")
            test -d "${WDIR}" || mkdir -p "${WDIR}"
            rm -f "${WFILE}"
            cp -a "${SFILE}" "${WFILE}"
        done
    else
        true
    fi
}

# extract the projects sources into the working directory
unpack()
{
    if ! [ "${PKG_ARCHIVE_FILE}" = "none" ] ; then
        tar -C ${BUILD_DIR} -xf ${PKG_ARCHIVE} || exit_failure "unable to extract ${PKG_ARCHIVE}"
        [ -d "${PKG_BUILD_DIR}" ] || exit_failure "${PKG_BUILD_DIR} was not found in archive"
    fi

    copy_overlay
}

# remove in installed project fieles from the staging area
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
    unpack
    configure
    compile
    install_staging
}
