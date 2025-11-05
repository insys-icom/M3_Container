#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="idna-3.11"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="04c67db54fa23cd6d2276009f17ac8424471d6a7afa42e9b3e3805c93925eb0a"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

PYTHON_VERSION="python3.14"

configure()
{
    true
}

compile()
{
    true
}

install_staging()
{
    cd "${PKG_BUILD_DIR}"
    mkdir -p "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/site-packages"
    cp -a "${PKG_BUILD_DIR}/idna" "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/site-packages/"
}

uninstall_staging()
{
    rm -rf "${STAGING_DIR}/usr/local/lib/${PYTHON_VERSION}/site-packages/idna"
}

. ${HELPERSDIR}/call_functions.sh
