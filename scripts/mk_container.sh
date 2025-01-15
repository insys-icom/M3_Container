#!/bin/sh

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)

# init possible entries of a MANIFEST
FILENAME=""
FILESIZE=""
FILETYPE=""
DESCRIPTION=""
VERSION=""
MD5SUM=""
KEY=""
FILESYSTEM_LIST=""

# print parameter list of this script
usage()
{
    echo "Usage: mk_container.sh <-n FILENAME> [-l ROOTFS-LIST] [-k KEY] [-d DESCRIPTION] [-v VERSION]"
    echo "    -n  name of the update packet with container to be packed"
    echo "    -l  use this file in the directory \"scripts/rootfs_lists/\" to fill the root file system of container"
    echo "    -k  use this RSA key in the directory \"scripts/keys/\" to encrypt the container"
    echo "    -d  use that description within MANIFEST"
    echo "    -v  use that version string within MANIFEST"
    echo ""
}

# create the MANIFEST file
print_manifest_entry()
{
    echo "FILENAME=${FILENAME}.tar.xz"
    echo "FILESIZE=${FILESIZE}"
    echo "FILETYPE=Container"
    echo "MD5SUM=${MD5SUM}"
    [ "${KEY}" ] && echo "KEY=${KEY}.router"
    [ "${VERSION}" ] && echo "VERSION=${VERSION}"
    [ "${DESCRIPTION}" ] && echo "DESCRIPTION=${DESCRIPTION}"
    echo ""
}

# read all options from command line
get_options()
{
    while [ -n "${1}" ] ; do
        case "${1}" in
            "-n")
                shift
                FILENAME="${1}"
            ;;
            "-l")
                shift
                FILESYSTEM_LIST="${1}"
            ;;
            "-d")
                shift
                DESCRIPTION="${1}"
            ;;
            "-k")
                shift
                KEY="${1}"
            ;;
            "-v")
                shift
                VERSION="${1}"
            ;;
            "-a")
                shift
                ARCH="${1}"
            ;;
            "-h")
                usage
                exit 0
            ;;
            *)
                usage
            ;;
        esac
        shift
    done
}

# strips the file $1 if possible
do_strip()
{
    FILE_TYPE=$(file ${1})
    if echo "${FILE_TYPE}" | grep -q "${ELF_BINARY}" ; then
        if echo "${FILE_TYPE}" | grep -q "executable" ; then
            ${M3_TARGET}-strip "${1}" > /dev/null 2>&1
        else
            if echo "${FILE_TYPE}" | grep -q "shared object" ; then
                ${M3_TARGET}-strip "${1}" > /dev/null 2>&1
            else
                if echo "${FILE_TYPE}" | grep -q "BuildID" ; then
                    # kernel modules my not be fully stripped
                    ${M3_TARGET}-strip --strip-debug "${1}"
                fi
            fi
        fi
    fi
}

# print lines of all files into one temporary file
# $1 temporary file
# $2 original fs list file
resolve_includes()
{
    TMP_FILE="${1}"
    FILESYSTEM_LIST="${2}"

    if ! [ -e "${FILESYSTEM_LIST}" ] ; then
        echo "   ERROR: the given list file \"${FILESYSTEM_LIST}\" does not exist"
        exit 1
    fi

    OLDIFS=$IFS
    IFS=$'\n'
    for LINE in $(cat ${FILESYSTEM_LIST} | grep -F -v '#' | grep -Ev '^$' ) ; do
        TYPE=$(echo ${LINE} | tr -s ' ' | cut -s -d' ' -f1 | sed 's/^ *//' | sed 's/ *$//' )
        if [ "${TYPE}" == "include" ] ; then
            FILE=$(echo ${LINE} | tr -s ' ' | cut -s -d' ' -f2)
            FILE=$(eval "echo ${FILE}")
            FILESYSTEM_LIST_COPY="${FILESYSTEM_LIST}"
            INCLUDE_FILE=$(dirname $(realpath ${FILESYSTEM_LIST}))/"${FILE}"
            resolve_includes "${TMP_FILE}" "${INCLUDE_FILE}"
            FILESYSTEM_LIST="${FILESYSTEM_LIST_COPY}"
        else
            echo "${LINE}" >> "${TMP_FILE}"
        fi
    done
    IFS=$OLDIFS
}

# process the list of files and permissions for the filesystem
# $1 = fs list
# $2 = FS_OUTFILE
process_filesystem_list()
{
    FILESYSTEM_LIST="${1}"
    FS_OUTFILE="${2}"

    echo "  -> Creating archive of containers root file system"

    rm -f "${FS_OUTFILE}"
    rm -rf "${FS_TARGET_DIR}"
    mkdir "${FS_TARGET_DIR}"

    test -d $(dirname ${FS_OUTFILE}) || mkdir -p $(dirname ${FS_OUTFILE})
    OLDIFS=$IFS
    IFS=$'\n'
    for LINE in $(cat ${FILESYSTEM_LIST} | grep -F -v '#' | grep -Ev '^$' ) ; do
        TYPE=$(echo ${LINE} | tr -s ' ' | cut -s -d' ' -f1 | sed 's/^ *//' | sed 's/ *$//' )
        DESTINATION_FILE=$(eval echo ${LINE} | tr -s ' ' | cut -s -d' ' -f2 | sed 's/^ *//' | sed 's/ *$//' )
        PARAM_1=$(echo ${LINE} | tr -s ' ' | cut -s -d' ' -f3 | sed 's/^ *//' | sed 's/ *$//' )
        PARAM_2=$(echo ${LINE} | tr -s ' ' | cut -s -d' ' -f4 | sed 's/^ *//' | sed 's/ *$//' )
        PARAM_3=$(echo ${LINE} | tr -s ' ' | cut -s -d' ' -f5 | sed 's/^ *//' | sed 's/ *$//' )
        PARAM_4=$(echo ${LINE} | tr -s ' ' | cut -s -d' ' -f6 | sed 's/^ *//' | sed 's/ *$//' )

        # for file and slink set here, override for dir later on
        SOURCE_FILE=$(eval echo "${PARAM_1}")
        PERMISSON="${PARAM_2}"
        OWNER="${PARAM_3}"
        GROUP="${PARAM_4}"

        # we have to keep the "." in front of the path inside the tar file
        TAR_FILES=".${DESTINATION_FILE}"

        # remove symbolic links, because overwriting them will overwrite the link target
        test -L "${TARGET_DIR}${DESTINATION_FILE}" && rm "${TARGET_DIR}${DESTINATION_FILE}"

        case ${TYPE} in
            "file")
                cmp "${SOURCE_FILE}" "${TARGET_DIR}${DESTINATION_FILE}" > /dev/null 2>&1
                if [ $? -ne 0 ] ; then
                    cp -fL "${SOURCE_FILE}" "${TARGET_DIR}${DESTINATION_FILE}" || exit_failure "failed to copy ${DESTINATION_FILE}"
                    # make strip possible for ro files, permissions will be set inside the tar
                    chmod 0644 "${TARGET_DIR}${DESTINATION_FILE}"
                    do_strip "${TARGET_DIR}${DESTINATION_FILE}"
                fi
            ;;
            "dir")
                PERMISSON="${PARAM_1}"
                OWNER="${PARAM_2}"
                GROUP="${PARAM_3}"
                test -e "${TARGET_DIR}${DESTINATION_FILE}" -a ! -d "${TARGET_DIR}${DESTINATION_FILE}" && rm -f "${TARGET_DIR}${DESTINATION_FILE}"
                test -d "${TARGET_DIR}${DESTINATION_FILE}" || mkdir --mode=${PERMISSON} "${TARGET_DIR}${DESTINATION_FILE}" || exit_failure "failed to create directory ${DESTINATION_FILE}"
            ;;
            "slink")
                test -d "${TARGET_DIR}${DESTINATION_FILE}" && rm -rf "${TARGET_DIR}${DESTINATION_FILE}"
                ln -s "${SOURCE_FILE}" "${TARGET_DIR}${DESTINATION_FILE}" || exit_failure "failed to create symbolic link ${DESTINATION_FILE}"
            ;;
            "wildcard")
                # wildcard is a dedicated target, because this feature is not available in the original initramfs list format
                # we do not strip here, because it should only be used for specific group of files like doc and html templates
                TAR_FILES=""
                for SOURCE_FILE in $(eval echo "${PARAM_1}" | sort) ; do
                    FNAME=$(basename "${SOURCE_FILE}")
                    # ignore directories here
                    if [ -e "${SOURCE_FILE}" -a ! -d "${SOURCE_FILE}" ] ; then
                        cmp "${SOURCE_FILE}" "${TARGET_DIR}${DESTINATION_FILE}/${FNAME}" > /dev/null 2>&1
                        if [ $? -ne 0 ] ; then
                            cp -fL "${SOURCE_FILE}" "${TARGET_DIR}${DESTINATION_FILE}/${FNAME}" || exit_failure "failed to copy ${DESTINATION_FILE}/${FNAME}"
                        fi
                        TAR_FILES="${TAR_FILES} ./rootfs${DESTINATION_FILE}/${FNAME}"
                    fi
                done
            ;;
            *)
                echo "Warning: Don't know how to make a ${TYPE}"
            ;;
        esac

        # append file to tar
        echo "./rootfs/${TAR_FILES}" | xargs tar --append -f ${FS_OUTFILE} --directory="${FS_TARGET_DIR}" --no-recursion --numeric-owner --mode=${PERMISSON} --owner=${OWNER} --group=${GROUP}
    done
    IFS=$OLDIFS
}

# compression level 6 is used, because 9 MiB of decompression RAM is enough
# and it will double with each higher compression level
#
# $1 file to compress
# $2 compressed file
compress()
{
    [ -z ${CPU_THREADS} ] && CPU_THREADS=2
    xz -6 -T${CPU_THREADS} --keep --stdout "${1}" > "${2}"
    echo "  -> Compressed image size: $(du -sh ${2} | cut -f1)"
}

# encrypt a packed rootfs with a random key.
# The random key is encrypted with a locally stored RSA key pair and attached to the compressed root file system image
encrypt()
{
    echo "  -> Encypting compressed archive"

    # abort in case there is no key to encrypt with
    if ! [ -e  "${SCRIPTSDIR}/keys/${KEY}" ] ; then
        echo "  -> Generating the public and private RSA key pair in file ${SCRIPTSDIR}/keys/${KEY}"
        echo "   NEVER, EVER give this file to anyone!"

        # generate RSA key pair
        openssl genrsa -out "${SCRIPTSDIR}/keys/${KEY}" 2048 2> /dev/null

        # export public part of RSA key pair
        echo "  -> Export public key in separate file, load this file onto the router"
        openssl rsa -pubout -in "${SCRIPTSDIR}/keys/${KEY}" -out "${SCRIPTSDIR}/keys/${KEY}.router" -outform PEM 2> /dev/null

        # ATTENTION! Yes, it is true! Upload the _PUBLIC_ part of the key pair to the router
        # and mark it as non downloadable. The role of public and private keys is exchanged
        # in this case to avoid having both parts in the encrypted container file.
    fi
    echo "   - import the file \"${SCRIPTSDIR}/keys/${KEY}.router\" into the router and"
    echo "   - set its descrption to \"${KEY}.router\""
    echo "   - optionally lock the key, so it can not be downloaded any more"

    # generate a random 32 byte long string that will be used as temporary AES key
    dd if=/dev/urandom bs=32 count=1 2> /dev/null | base64 | dd bs=32 count=1 of="${BUILD_DIR}/update/aes.key" 2> /dev/null

    # use Openssl RSA utilities to encrypt the temporary AES key
    openssl rsautl -in "${BUILD_DIR}/update/aes.key" -out "${BUILD_DIR}/update/aes.key.crypt" -inkey "${SCRIPTSDIR}/keys/${KEY}" -sign

    # use temporary AES key to encrypt the file that containes compressed root file system
    openssl aes-256-cbc -in "${BUILD_DIR}/update/${FILENAME}.tar.xz" -out "${BUILD_DIR}/update/encrypted" -kfile "${BUILD_DIR}/update/aes.key" -e

    # remove the unecrypted file and rename the encrypted file
    rm "${BUILD_DIR}/update/${FILENAME}.tar.xz"
    mv "${BUILD_DIR}/update/encrypted" "${BUILD_DIR}/update/${FILENAME}.tar.xz"

    # append the generated key to the encrypted file
    dd if="${BUILD_DIR}/update/aes.key.crypt" of="${BUILD_DIR}/update/${FILENAME}.tar.xz" conv=notrunc oflag=append > /dev/null 2>&1

    # remove the temporarily used AES key pair
    rm "${BUILD_DIR}/update/aes.key" "${BUILD_DIR}/update/aes.key.crypt"
}

main()
{
    # get all options
    get_options "${@}"

    . "${TOPDIR}"/scripts/common_settings.sh
    UPDATE_TAR="${BUILD_DIR}/update/rootfs.tar"
    UPDATE_TAR_XZ="${UPDATE_TAR}.xz"
    [ "${ARCH}" ] || ARCH="armv7"

    # create the target directory for the container image, in case it does not exist, yet
    test -d ${OUTPUT_DIR} || mkdir ${OUTPUT_DIR}

    # save current date in rootfs
    date "+%Y-%m-%d %H:%M:%S" > "${SKELETON_DIR}/usr/share/build"

    # resolve all includes of the filesystem list file
    TMP_FILE=$(mktemp)
    resolve_includes "${TMP_FILE}" "${SCRIPTSDIR}/rootfs_lists/${FILESYSTEM_LIST}"

    # pack the root of the new container
    process_filesystem_list "${TMP_FILE}" "${UPDATE_TAR}"

    # remove the temporary file
    rm -f "${TMP_FILE}"

    # compress the tar with xz
    compress "${UPDATE_TAR}" "${UPDATE_TAR_XZ}"
    rm "${UPDATE_TAR}"

    # rename the image
    mv "${UPDATE_TAR_XZ}" "${BUILD_DIR}/update/${FILENAME}.tar.xz"

    # optionally encrypt archive
    ! [ "${KEY}" = "" ] && encrypt

    CONTAINER_FILENAME="${OUTPUT_DIR}/${FILENAME}_$(date +%Y-%m-%d_%H%M%S).tar"
    if [ "${ARCH}" == amd64 ] ; then
        # move created file
        mv "${BUILD_DIR}/update/${FILENAME}.tar.xz" "${CONTAINER_FILENAME}"
    else
        # create a update packet consisting of the root FS of the container and the MANIFEST
        FILESIZE="$(stat -c %s "${BUILD_DIR}/update/${FILENAME}.tar.xz")"
        MD5SUM="$(md5sum "${BUILD_DIR}/update/${FILENAME}.tar.xz" | cut -b1-32)"
        MANIFEST="${BUILD_DIR}/update/MANIFEST"
        print_manifest_entry >> "${MANIFEST}"

        rm -f "${CONTAINER_FILENAME}"
        cd "${BUILD_DIR}/update"
        tar -cf "${CONTAINER_FILENAME}" "MANIFEST" "${FILENAME}.tar.xz"
    fi

    # create symlink to latest image
    rm -f "${OUTPUT_DIR}/${FILENAME}"
    rm -f "${OUTPUT_DIR}/${FILENAME}.tar"
    cd "${OUTPUT_DIR}"
    ln -s $(basename ${CONTAINER_FILENAME}) "${FILENAME}.tar"

    # get rid of the working files
    rm -Rf "${BUILD_DIR}/update"

    echo -en "  -> Final update packet with the container is stored in ${CONTAINER_FILENAME}\n\n"
}

main "${@}"
