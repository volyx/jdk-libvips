FROM openjdk:11.0.3-jdk-slim

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  automake build-essential curl \
  cdbs debhelper dh-autoreconf flex bison \
  libjpeg-dev libtiff-dev libpng-dev libgif-dev librsvg2-dev libpoppler-glib-dev zlib1g-dev fftw3-dev liblcms2-dev \
  liblcms2-dev libmagickwand-dev libfreetype6-dev libpango1.0-dev libfontconfig1-dev libglib2.0-dev libice-dev \
  gettext pkg-config libxml-parser-perl libexif-gtk-dev liborc-0.4-dev libopenexr-dev libmatio-dev libxml2-dev \
  libcfitsio-dev libopenslide-dev libwebp-dev libgsf-1-dev libgirepository1.0-dev gtk-doc-tools

ENV LIBVIPS_VERSION_MAJOR 8
ENV LIBVIPS_VERSION_MINOR 6
ENV LIBVIPS_VERSION_PATCH 1
ENV LIBVIPS_VERSION $LIBVIPS_VERSION_MAJOR.$LIBVIPS_VERSION_MINOR.$LIBVIPS_VERSION_PATCH

#curl -L -O https://github.com/jcupitt/libvips/archive/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.gz && \
# https://github.com/libvips/libvips/releases/download/v8.8.0/vips-8.8.0.tar.gz

RUN \
  # Build libvips
  cd /tmp && \
  curl -L -O https://github.com/libvips/libvips/releases/download/v$LIBVIPS_VERSION/vips-$LIBVIPS_VERSION.tar.gz && \
  tar zxvf vips-$LIBVIPS_VERSION.tar.gz && \
  cd /tmp/vips-$LIBVIPS_VERSION && \
  ./configure --enable-debug=no --without-python $1 && \
  make && \
  make install && \
  ldconfig

RUN \
  # Clean up
  apt-get remove -y automake curl build-essential && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*