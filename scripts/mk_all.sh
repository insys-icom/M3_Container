#!/bin/sh

echo "This script will "
echo " - erase already created containers in \"images\""
echo " - erase everything in the directories \"rootfs_staging\" and \"working\""
echo " - erase all downloaded open source packets in \"oss_packages/dl\""
echo " - compile all open source projects given in the file \"oss_packages/scripts/helpers/list.txt\""
echo " - create all containers for witch cooking recipes exist (\"/scripts/create_container_XXX.sh\")"
echo " "
echo "Continue? <y/n>"

read text
! [ "${text}" = "y" -o "${text}" = "yes" ] && exit 0

SCRIPTSDIR=$(dirname $0)
TOPDIR=$(realpath ${SCRIPTSDIR}/..)
source ${TOPDIR}/scripts/common_settings.sh
LIST_FILE="${OSS_PACKAGES_SCRIPTS}/helpers/list.txt"
source ${TOPDIR}/scripts/helpers.sh

# clean up
rm -Rf "${TOPDIR}/images/"*
rm -Rf "${STAGING_DIR}/"*
rm -Rf "${TOPDIR}/working/"*
rm -Rf "${DOWNLOADS_DIR}/"*

# build all open source projects in the order given by the list file
while read BUILDSCRIPT ; do
    # ignore line with starting # or space
    [ "$(echo $BUILDSCRIPT | cut -c1-1)" = '#' -o "$(echo $BUILDSCRIPT | cut -c1-1)" = "" ] && continue

    # announce the build script
    echo ""
    echo "###########################################################################"
    printf "executing \"%s$BUILDSCRIPT all\"\n"
    echo "###########################################################################"

    # set terminal title
    echo -ne "\033]0;$BUILDSCRIPT\007"

    # process build script
    "${OSS_PACKAGES_SCRIPTS}/${BUILDSCRIPT}" all || exit_failure "Failed to execute ${BUILDSCRIPT} all"
done < $(ls ${LIST_FILE})

# create all containers
cd "${SCRIPTSDIR}/rootfs_lists"
for LIST in *.txt ; do
    NAME="container_$(echo $LIST | cut -d'.' -f1)"
    echo -ne "\033]0;creating $NAME\007"
    DATE=$(date +\"%F\")
    "${TOPDIR}"/scripts/mk_container.sh -n "${NAME}" -l "${LIST}" -v "${DATE}" || exit_failure "Failed to create ${NAME}.tar"
done

# execute an upload script in case it exists
echo -ne "\033]0;Uploading containers\007"
[ -e ~/m3_upload.sh ] && ~/m3_upload.sh

# reset terminal title
echo -ne "\033]0;M3SDK\007"
