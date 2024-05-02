FROM ubuntu:24.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    ccache \
    gzip \
    git \
    software-properties-common \
    autoconf \ 
    automake \ 
    autopoint \ 
    gettext \ 
    autotools-dev \ 
    cmake \ 
    curl \ 
    default-jre \ 
    gawk \ 
    gcc \
    g++ \ 
    cpp \ 
    gdc \ 
    gperf \ 
    libass-dev \ 
    libavahi-client-dev \ 
    libavahi-common-dev \ 
    libbluetooth-dev \ 
    libbluray-dev \ 
    libbz2-dev \ 
    libcdio-dev \ 
    libcec-dev \ 
    libp8-platform-dev \ 
    libcrossguid-dev \ 
    libcurl4-gnutls-dev \ 
    libcwiid-dev \ 
    libdbus-1-dev \ 
    libegl1-mesa-dev \ 
    libenca-dev \ 
    libflac-dev \ 
    libfontconfig-dev \ 
    libfmt-dev \ 
    libfreetype6-dev \ 
    libfribidi-dev \ 
    libfstrcmp-dev \ 
    libgcrypt-dev \ 
    libgif-dev \ 
    libgles2-mesa-dev \
    libgl1-mesa-dev \ 
    libgl-dev \ 
    libglew-dev \ 
    libglu1-mesa-dev \
    libglu-dev \  
    libgnutls28-dev \ 
    libgpg-error-dev \ 
    libgtest-dev \ 
    libiso9660-dev \ 
    libjpeg-dev \ 
    liblcms2-dev \ 
    liblirc-dev \ 
    libltdl-dev \ 
    liblzo2-dev \ 
    libmicrohttpd-dev \ 
    libmysqlclient-dev \ 
    libnfs-dev \ 
    libogg-dev \ 
    libomxil-bellagio-dev \ 
    libpcre3-dev \ 
    libplist-dev \ 
    libpng-dev \ 
    libpulse-dev \ 
    libshairplay-dev \ 
    libsmbclient-dev \ 
    libspdlog-dev \ 
    libsqlite3-dev \ 
    libssl-dev \ 
    libtag1-dev \ 
    libtiff-dev \ 
    libtinyxml-dev \ 
    libtinyxml2-dev \ 
    libtool \ 
    libudev-dev \ 
    libunistring-dev \ 
    libva-dev \ 
    libvdpau-dev \ 
    libvorbis-dev \ 
    libxkbcommon-dev \ 
    libxmu-dev \ 
    libxrandr-dev \ 
    libxslt-dev \ 
    libxt-dev \ 
    wipe \ 
    lsb-release \ 
    meson \ 
    nasm \ 
    ninja-build \ 
    python3-dev \ 
    python3-pil \ 
    python3-minimal \ 
    rapidjson-dev \ 
    swig \ 
    unzip \ 
    uuid-dev \ 
    zip \ 
    zlib1g-dev \
    libdrm-dev \
    libdisplay-info-dev \
    libgbm-dev \
    libinput-dev

WORKDIR /kodi

RUN git clone https://github.com/xbmc/xbmc.git

COPY build.sh /usr/local/bin

WORKDIR /kodi/build

RUN build.sh

FROM ubuntu:24.04 AS runner

RUN apt-get update && apt-get install -y dumb-init ca-certificates

WORKDIR /tmp

COPY --from=builder \
  /kodi/build/packages/kodi-bin*.deb \ 
  /kodi/build/packages/kodi-addon*.deb \
  /kodi/build/packages/kodi_*_all.deb \
  /kodi/build/packages/kodi-tools*.deb \
  ./

RUN apt-get install -y ./*.deb && rm -rf *.deb

RUN echo "allowed_users=anybody\nneeds_root_rights=yes" > /etc/X11/Xwrapper.config

WORKDIR /home/ubuntu

VOLUME ["/home/ubuntu/.kodi"]

ENTRYPOINT ["dumb-init", "--"]

USER ubuntu

CMD ["kodi"]