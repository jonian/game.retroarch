#!/bin/sh

set -e

VERSION="${VERSION:-1.16.0.3}"
LIBREELEC="${LIBREELEC:-11}"
DEVICE="${DEVICE:-RPi4}"

PLATFORM="linux/arm/v7"
VIDEOCORE="no"
VULKAN="no"
OPENGLES3="no"

if [ "${LIBREELEC}" -lt "10" ]; then
  VIDEOCORE="yes"
fi

if [ "${LIBREELEC}" -ge "11" ]; then
  VULKAN="yes"
fi

if [ "${DEVICE}" = "RPi4" ] || [ "${DEVICE}" = "RPi5" ]; then
  if [ "${LIBREELEC}" -ge "10" ]; then
    OPENGLES3="yes"
  fi

  if [ "${LIBREELEC}" -ge "12" ]; then
    PLATFORM="linux/arm64"
  fi
fi

echo ""
echo "  RetroArch  : ${VERSION}"
echo "  LibreELEC  : ${LIBREELEC}"
echo "  RPi Device : ${DEVICE}"
echo ""
echo "  Platform   : ${PLATFORM}"
echo "  VideoCore  : ${VIDEOCORE}"
echo "  OpenGLESv3 : ${VULKAN}"
echo "  Vulkan     : ${VULKAN}"
echo ""

cpu_cores=$(nproc --ignore=2)
image_name=game.retroarch:$VERSION

docker build \
  --progress=plain \
  --platform ${PLATFORM} \
  --build-arg JOBS="${JOBS:-$cpu_cores}" \
  --build-arg VERSION="${VERSION}" \
  --build-arg VIDEOCORE="${VIDEOCORE}" \
  --build-arg VULKAN="${VULKAN}" \
  --build-arg OPENGLES3="${OPENGLES3}" \
  --tag $image_name \
  docker

container_id=$(docker create --platform $PLATFORM $image_name)
build_path=build

mkdir -p $build_path

docker cp \
  $container_id:/root/RetroArch/retroarch \
  $build_path/game.retroarch
