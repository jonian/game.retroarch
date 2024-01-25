#!/bin/sh

set -e

CORE="${CORE:-lutro}"
ARCH="${ARCH:-armv7}"
DEVICE="${DEVICE:-RPi4}"

if [ "${ARCH}" = "arm64" ]; then
  PLATFORM="linux/arm64"
else
  PLATFORM="linux/arm/v7"
fi

current_file=$(realpath "$0")
current_dir=$(dirname "$current_file")
parent_dir=$(dirname "$current_dir")

cpu_cores=$(nproc --ignore=2)
image_name=game.libretro:$ARCH-$CORE

docker build \
  --progress=plain \
  --platform ${PLATFORM} \
  --build-arg JOBS="${JOBS:-$cpu_cores}" \
  --build-arg DEVICE="${DEVICE}" \
  --build-arg CORE="${CORE}" \
  --tag $image_name \
  $current_dir

container=$(docker create --platform $PLATFORM $image_name)
build_path=$parent_dir/build/libretro

mkdir -p $build_path

docker cp \
  $container:/root/LibRetro/install/usr/lib/libretro/. \
  $build_path
