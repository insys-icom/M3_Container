#!/bin/bash

ARCHITECTURES="armv7 amd64 aarch64"

SCRIPTS=$(realpath $(dirname ${BASH_SOURCE[0]}))
TOPDIR=$(realpath ${SCRIPTS}/..)
. "${TOPDIR}"/scripts/common_settings.sh

for ARCH in ${ARCHITECTURES}; do
    rm -Rf "${TOPDIR}"/working/"${ARCH}"/*
    rm -Rf "${TOPDIR}"/images/"${ARCH}"/*
    rm -Rf "${TOPDIR}"/rootfs_staging/"${ARCH}"/*
done

# find all scripts that are named "create_container_*" and retrieve their needed OSS packages without executing the build
SUM=()
for i in $(ls ${SCRIPTS}); do
    if [[ "${i}" == *"create_container_"* ]]; then
        # get container specific variables
        . "${SCRIPTS}"/"${i}" do_nothing

        index=0
        # walk over all package groups
        for i in "${PACKAGES[@]}"; do
            group=${SUM[$index]}
            PACKAGE=("${!i}")
            # walk over all packages in this group
            for p in "${PACKAGE[@]}"; do
                # only add package to the group list, if it is not already in there
                if ! [[ "${group}" == *"${p}"* ]]; then
                    group+="${p} "
                fi
            done
            SUM[$index]=$group
            index=$((index+1))
        done
    fi
done

for ARCH in ${ARCHITECTURES}; do
    . "${TOPDIR}"/scripts/common_settings.sh

    # create a symlinks and directories in staging area
    cd "${STAGING_DIR}"
    mkdir -p bin etc include lib libexec sbin share ssl usr var
    [ -e "lib64" ] || ln -s lib lib64
    cd "${TOPDIR}"/

    # build all the OSS packages
    echo " "
    echo "Compiling in parallel for ${ARCH}:"
    echo "------------------------------------------------------"
    for i in "${SUM[@]}"; do
        for p in $i; do
           echo "    Compile ${p}"
           ARCH=${ARCH} ${OSS_PACKAGES_SCRIPTS}/${p} all > "${BUILD_DIR}/${p}.log" 2>&1 &
        done
        wait || exit_failure "Failed to build ${p}"
        echo "    --------------------------------------------------"
    done

    # build all the closed packages
    echo ""
    echo "Compiling closed packages:"
    echo "------------------------------------------------------"
    for i in "${CLOSED_PACKAGES[@]}"; do
        CLOSED_PACKAGE=("${!i}")
        for p in "${CLOSED_PACKAGE[@]}"; do
            echo "    Compile ${p}"
            ARCH=${ARCH} ${CLOSED_PACKAGES_DIR}/${p} all > "${BUILD_DIR}/${p}.log" 2>&1 &
        done
        wait || exit_failure "Failed to build ${p}"
        echo "    --------------------------------------------------"
    done

    # create all Update Packets
    for i in $(ls ${SCRIPTS}); do
        if [[ "${i}" == *"create_container_"* ]]; then
            # get container specific variables again
            . "${SCRIPTS}"/"${i}" do_nothing
            "${SCRIPTS}"/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0" -a "${ARCH}"
            echo "---------------------------------------------------------------------------------------"
        fi
    done
done
