#!/bin/sh

# name of directory after extracting the archive in working directory
PKG_DIR="SDL2-2.0.8"

# name of the archive in dl directory (use "none" if empty)
PKG_ARCHIVE_FILE="${PKG_DIR}.tar.gz"

# download link for the sources to be stored in dl directory (use "none" if empty)
# PKG_DOWNLOAD="#https://www.libsdl.org/release/${PKG_ARCHIVE_FILE}"
PKG_DOWNLOAD="https://m3-container.net/M3_Container/oss_packages/${PKG_ARCHIVE_FILE}"

# md5 checksum of archive in dl directory (use "none" if empty)
PKG_CHECKSUM="3800d705cef742c6a634f202c37f263f"



SCRIPTSDIR=$(dirname $0)
HELPERSDIR="${SCRIPTSDIR}/helpers"
TOPDIR=$(realpath ${SCRIPTSDIR}/../..)
. "${TOPDIR}/scripts/common_settings.sh"
. "${HELPERSDIR}/functions.sh"
PKG_ARCHIVE="${DOWNLOADS_DIR}/${PKG_ARCHIVE_FILE}"
PKG_SRC_DIR="${SOURCES_DIR}/${PKG_DIR}"
PKG_BUILD_DIR="${BUILD_DIR}/${PKG_DIR}"
PKG_INSTALL_DIR="${PKG_BUILD_DIR}/install"

configure()
{
    cd "${PKG_BUILD_DIR}"
    CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_INCLUDE}/directfb" \
         LDFLAGS="${M3_LDFLAGS} -L${STAGING_LIB}" \
        ./configure --host=${M3_TARGET} --prefix="" \
            PKG_CONFIG=pkg-config \
            PKG_CONFIG_LIBDIR="${STAGING_LIB}/pkgconfig" \
            --enable-video-directfb \
            --enable-directfb-shared \
            --enable-input-tslib \
            --disable-audio \
            --disable-pulseaudio \
            --disable-joystick \
            --disable-pulseaudio-shared \
            --disable-diskaudio \
            --disable-dummyaudio \
            --disable-libsamplerate \
            --disable-fusionsound \
            --disable-sndio-shared \
            --disable-sndio \
            --disable-nas-shared \
            --disable-nas \
            --disable-arts-shared \
            --disable-esd-shared \
            --disable-jack-shared \
            --disable-jack \
            --disable-alsa-shared \
            --disable-alsa \
            --disable-oss \
            --disable-dbus \
            --disable-video-opengl \
            --disable-video-opengles \
            --disable-video-opengles1 \
            --disable-video-opengles2 \
            --disable-video-vulkan \
            --disable-video-x11 \
            --disable-x11-shared \
            --disable-video-wayland \
            --disable-wayland-shared \
            --disable-directx \
            || exit_failure "failed to configure ${PKG_DIR}"
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
    make CFLAGS="${M3_CFLAGS} -I${STAGING_INCLUDE} -I${STAGING_INCLUDE}/directfb" DESTDIR="${STAGING_DIR}" install \
        || exit_failure "failed to install ${PKG_DIR} to ${STAGING_DIR}"

    sed -i '/^dependency_libs=/s% /lib/libts.la% '${STAGING_DIR}'/lib/libts.la%' ${STAGING_DIR}/lib/libSDL2.la
}

. ${HELPERSDIR}/call_functions.sh

