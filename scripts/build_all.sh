#!/bin/bash

SCRIPTS=$(realpath $(dirname ${BASH_SOURCE[0]}))
TOPDIR=$(realpath ${SCRIPTS}/..)

rm -Rf "${TOPDIR}"/working/*
rm -Rf "${TOPDIR}"/images/*
rm -Rf "${TOPDIR}"/rootfs_staging/*

P_1=""
P_2=""
P_3=""
P_4=""

# search if given arguments already appear in string P_1
contains_1() {
    for PACKAGE in ${@} ; do
        if ! [[ "${P_1}" == *"${PACKAGE}"* ]]; then
            P_1+=" ${PACKAGE}"
        fi
    done
}

# search if given arguments already appear in string P_2
contains_2() {
    for PACKAGE in ${@} ; do
        if ! [[ "${P_2}" == *"${PACKAGE}"* ]]; then
            P_2+=" ${PACKAGE}"
        fi
    done
}

# search if given arguments already appear in string P_3
contains_3() {
    for PACKAGE in ${@} ; do
        if ! [[ "${P_3}" == *"${PACKAGE}"* ]]; then
            P_3+=" ${PACKAGE}"
        fi
    done
}

# search if given arguments already appear in string P_4
contains_4() {
    for PACKAGE in ${@} ; do
        if ! [[ "${P_4}" == *"${PACKAGE}"* ]]; then
            P_4+=" ${PACKAGE}"
        fi
    done
}

# find all scripts that are named "create_container_*" and retrieve their needed OSS packages without executing the build
for i in $(ls ${SCRIPTS}); do
    if [[ "${i}" == *"create_container_"* ]]; then
        # get container specific variables
        . "${SCRIPTS}"/"${i}" do_nothing
        contains_1 "${PACKAGES_1}"
        contains_2 "${PACKAGES_2}"
        contains_3 "${PACKAGES_3}"
        contains_4 "${PACKAGES_4}"
    fi
done

# build all the OSS packages
PACKAGES_1="$P_1"
PACKAGES_2="$P_2"
PACKAGES_3="$P_3"
PACKAGES_4="$P_4"
. "${SCRIPTS}"/create.sh do_not_package

# create all Update Packets
for i in $(ls ${SCRIPTS}); do
    if [[ "${i}" == *"create_container_"* ]]; then
        echo ""
        # get container specific variables again
        . "${SCRIPTS}"/"${i}" do_nothing
        "${SCRIPTS}"/mk_container.sh -n "${CONTAINER_NAME}" -l "${ROOTFS_LIST}" -d "${DESCRIPTION}" -v "1.0"
        echo "---------------------------------------------------------------------------------------"
    fi
done
