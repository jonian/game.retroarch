#!/bin/sh

ARCH=$(uname -m)

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
  --enable-alsa"

MAKE_OPTIONS="V=1 \
  HAVE_LAKKA=0 \
  HAVE_HAVE_ZARCH=0 \
  HAVE_WIFI=0 \
  HAVE_BLUETOOTH=0 \
  HAVE_FREETYPE=1"

if [ "${SUPPORT_VIDEOCORE}" = "yes" ]; then
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --enable-videocore --disable-kms"
else
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --disable-videocore --enable-kms"
fi

if [ "${SUPPORT_VULKAN}" = "yes" ]; then
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --enable-vulkan"
else
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --disable-vulkan"
fi

if [ "${SUPPORT_OPENGLES3}" = "yes" ]; then
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --enable-opengles3 --enable-opengles3_1"
fi

if [ "${ARCH}" = "armv7l" ]; then
  CONFIG_FLAGS="-mfpu=neon"
  CONFIG_OPTIONS="${CONFIG_OPTIONS} --enable-neon --enable-floathard"
fi

echo ""
echo " CFLAGS : ${CONFIG_FLAGS:-none}"
echo " CONFIG : ${CONFIG_OPTIONS}"
echo ""

CFLAGS="${CONFIG_FLAGS}" ./configure $CONFIG_OPTIONS && make -j4 $MAKE_OPTIONS
