#!/bin/sh

. /root/config/package

CONFIG_OPTIONS="--disable-vg \
  --disable-sdl \
  --disable-sdl2 \
  --disable-ssl \
  --disable-x11 \
  --disable-wayland \
  --disable-pulse \
  --disable-opengl \
  --enable-zlib \
  --enable-freetype \
  --enable-egl \
  --enable-opengles \
  --enable-hid \
  --enable-alsa"

MAKE_OPTIONS="V=1 \
  HAVE_LAKKA=0 \
  HAVE_HAVE_ZARCH=0 \
  HAVE_WIFI=0 \
  HAVE_BLUETOOTH=0 \
  HAVE_FREETYPE=1"

if [ "${OPENGLES}" = "bcm2835-driver" ]; then
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --enable-videocore --disable-kms"
  sed -i 's/HAVE_CRTSWITCHRES=auto/HAVE_CRTSWITCHRES=no/' qb/config.params.sh
else
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --disable-videocore --enable-kms"
fi

if [ "${VULKAN_SUPPORT}" = "yes" ]; then
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --enable-vulkan"
else
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --disable-vulkan"
fi

if [ "${DEVICE}" = "RPi4" ] || [ "${DEVICE}" = "RPi5" ]; then
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --enable-opengles3 --enable-opengles3_1"
fi

if [ "${ARCH}" = "arm" ]; then
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --enable-neon --enable-floathard"
fi

echo ""
echo "  RetroArch : ${VERSION}"
echo "  LibreELEC : ${LIBREELEC}"
echo "  Project   : ${PROJECT}"
echo "  Device    : ${DEVICE}"
echo "  Arch      : ${ARCH}"
echo "  Features  : ${TARGET_FEATURES}"
echo ""
echo "  CFLAGS    : ${CFLAGS:-none}"
echo "  CXXFLAGS  : ${CXXFLAGS:-none}"
echo "  LDFLAGS   : ${LDFLAGS:-none}"
echo ""
echo "  TOOLCHAIN : make"
echo "  MAKEOPTS  : ${MAKE_OPTIONS}"
echo "  CONFIGURE : ${CONFIG_OPTIONS}"
echo ""

./configure $CONFIG_OPTIONS && make $MAKE_OPTIONS -j $JOBS
