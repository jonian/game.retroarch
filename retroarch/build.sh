#!/bin/sh

set -e

IMAGE="bullseye"

VERSION="${VERSION:-1.18.0}"
LIBREELEC="${LIBREELEC:-11}"

DEVICE="${DEVICE:-RPi4}"
PLATFORM="linux/arm/v7"

if [ "${LIBREELEC}" -lt "10" ]; then
  IMAGE="buster"
fi

if [ "${LIBREELEC}" -ge "12" ]; then
  IMAGE="trixie"
fi

if [ "${DEVICE}" = "RPi4" ] && [ "${LIBREELEC}" -lt "10" ]; then
  echo "LibreELEC ${LIBREELEC} not supported on ${DEVICE} devices!"
  exit 1
fi

if [ "${DEVICE}" = "RPi5" ] && [ "${LIBREELEC}" -lt "11" ]; then
  echo "LibreELEC ${LIBREELEC} not supported on ${DEVICE} devices!"
  exit 1
fi

if [ "${DEVICE}" = "RPi4" ] || [ "${DEVICE}" = "RPi5" ]; then
  if [ "${LIBREELEC}" -ge "12" ]; then
    PLATFORM="linux/arm64"
  fi
fi

current_file=$(realpath "$0")
current_dir=$(dirname "$current_file")
parent_dir=$(dirname "$current_dir")

cpu_cores=$(nproc --ignore=2)
image_name=game.retroarch:$VERSION

docker build \
  --progress=plain \
  --platform ${PLATFORM} \
  --build-arg JOBS="${JOBS:-$cpu_cores}" \
  --build-arg IMAGE="${IMAGE}" \
  --build-arg VERSION="${VERSION}" \
  --build-arg DEVICE="${DEVICE}" \
  --build-arg LIBREELEC="${LIBREELEC}" \
  --tag $image_name \
  $current_dir

container_id=$(docker create --platform $PLATFORM $image_name)
build_path=$parent_dir/build

mkdir -p $build_path

docker cp \
  $container_id:/root/RetroArch/retroarch \
  $build_path/game.retroarch
