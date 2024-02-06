FROM jonian/rpi-buildenv:buster

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install dependencies
RUN apt-get update && apt-get install -yq \
      libegl1-mesa-dev \
      libgles2-mesa-dev \
      libvulkan-dev \
      libasound2-dev \
      libgbm-dev \
      libdrm-dev \
      libudev-dev \
      libxkbcommon-dev \
      libbluetooth-dev \
      libusb-1.0-0-dev \
      libxml2-dev \
      libfontconfig-dev \
      libavdevice-dev \
      libavcodec-dev \
      libavformat-dev \
      libswscale-dev \
      libavutil-dev \
      libspeex-dev \
      libpng-dev \
      libjpeg-dev \
      zlib1g-dev \
      mesa-vulkan-drivers \
      ffmpeg \
      yasm

# Download RetroArch package
WORKDIR /root

ARG VERSION=1.17.0

RUN wget https://github.com/libretro/RetroArch/archive/refs/tags/v${VERSION}.tar.gz \
  && tar xf v${VERSION}.tar.gz \
  && mv RetroArch-${VERSION} RetroArch \
  && rm v${VERSION}.tar.gz

# Copy project files
COPY ./scripts .

# Build RetroArch
WORKDIR /root/RetroArch

ARG JOBS=1
ENV JOBS=$JOBS

ARG VIDEOCORE=no
ARG VULKAN=no
ARG OPENGLES3=no

ENV SUPPORT_VIDEOCORE=$VIDEOCORE
ENV SUPPORT_VULKAN=$VULKAN
ENV SUPPORT_OPENGLES3=$OPENGLES3

RUN sh /root/build.sh
