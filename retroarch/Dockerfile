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

# Build RetroArch
WORKDIR /root/RetroArch

ARG LIBREELEC=11
ENV LIBREELEC=$LIBREELEC

# Copy project files and fetch sources
COPY ./config/options /root/config/
COPY ./scripts/fetch.sh /root/scripts/

RUN bash /root/scripts/fetch.sh

ARG DEVICE=RPi4
ENV DEVICE=$DEVICE

ARG JOBS=1
ENV JOBS=$JOBS

# Copy project files and build
COPY ./config/. /root/config/
COPY ./scripts/build.sh /root/scripts/

RUN bash /root/scripts/build.sh

# Strip retroarch binary
RUN strip --strip-unneeded retroarch
