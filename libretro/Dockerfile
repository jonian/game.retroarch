FROM jonian/rpi-buildenv:bullseye

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -yq \
      libegl1-mesa-dev \
      libgles2-mesa-dev \
      libgl1-mesa-dev \
      libvulkan-dev \
      libasound2-dev \
      libgbm-dev \
      libdrm-dev \
      libudev-dev \
      libxml2-dev \
      libfreetype6-dev \
      libavcodec-dev \
      libpng-dev \
      libjpeg-dev \
      libusb-dev \
      libpcap-dev \
      libzip-dev \
      libzstd-dev \
      libspeex-dev \
      zlib1g-dev \
      mesa-vulkan-drivers \
      python3 \
      ccache \
      bzip2 \
      clang \
      cmake \
      meson \
      ninja-build \
      libtool-bin \
      autoconf \
      automake \
      gettext \
      yasm

# Download Lakka package
WORKDIR /root
RUN git clone --depth=1 https://github.com/libretro/Lakka-LibreELEC Lakka

# Build LibRetro cores
WORKDIR /root/LibRetro

ARG CORE=lutro
ENV PACKAGE=$CORE

# Copy project files and fetch source
COPY ./config/options /root/config/
COPY ./packages*/${CORE} /root/packages/
COPY ./scripts/fetch.sh /root/scripts/

RUN bash /root/scripts/fetch.sh

ARG DEVICE=RPi4
ENV DEVICE=$DEVICE

ARG JOBS=1
ENV JOBS=$JOBS

# Copy project files and build
COPY ./config/. /root/config/
COPY ./patches*/${CORE} /root/patches/
COPY ./scripts/build.sh /root/scripts/

RUN bash /root/scripts/build.sh
