FROM ubuntu:24.04 AS builder

RUN apt-get update && apt-get install -y \
    git \
    gzip \
    debhelper \ 
    autoconf \ 
    automake \ 
    autopoint \ 
    gettext \ 
    autotools-dev \ 
    cmake \ 
    curl \ 
    default-jre \ 
    doxygen \ 
    gawk \ 
    gcc \ 
    gdc \ 
    gperf \ 
    libasound2-dev \ 
    libass-dev \ 
    libavahi-client-dev \ 
    libavahi-common-dev \ 
    libbluetooth-dev \ 
    libbluray-dev \ 
    libbz2-dev \ 
    libcdio-dev \ 
    libp8-platform-dev \ 
    libcrossguid-dev \ 
    libcurl4-openssl-dev \ 
    libcwiid-dev \ 
    libdbus-1-dev \ 
    libdrm-dev \ 
    libegl1-mesa-dev \ 
    libenca-dev \ 
    libflac-dev \ 
    libfmt-dev \ 
    libfontconfig-dev \ 
    libfreetype6-dev \ 
    libfribidi-dev \ 
    libfstrcmp-dev \ 
    libgcrypt-dev \ 
    libgif-dev \ 
    libgles2-mesa-dev \ 
    libgl1-amber-dev \ 
    libglu1-mesa-dev \ 
    libgnutls28-dev \ 
    libgpg-error-dev \ 
    libgtest-dev \ 
    libiso9660-dev \ 
    libjpeg-dev \ 
    liblcms2-dev \ 
    libltdl-dev \ 
    liblzo2-dev \ 
    libmicrohttpd-dev \ 
    libmysqlclient-dev \ 
    libnfs-dev \ 
    libogg-dev \ 
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
    libtiff5-dev \ 
    libtinyxml-dev \ 
    libtinyxml2-dev \ 
    libtool \ 
    libudev-dev \ 
    libunistring-dev \ 
    libva-dev \ 
    libvdpau-dev \ 
    libvorbis-dev \ 
    libxmu-dev \ 
    libxrandr-dev \ 
    libxslt1-dev \ 
    libxt-dev \ 
    lsb-release \ 
    meson \ 
    nasm \ 
    ninja-build \ 
    python3-dev \ 
    python3-pil \ 
    python3-pip \ 
    rapidjson-dev \ 
    swig \ 
    unzip \ 
    uuid-dev \ 
    zip \ 
    zlib1g-dev \
    libcec-dev \
    libfmt-dev \
    liblirc-dev \
    libcap-dev \
    libsndio-dev 

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

WORKDIR /home/ubuntu

VOLUME ["/home/ubuntu/.kodi"]

ENTRYPOINT ["dumb-init", "--"]

USER ubuntu

CMD ["kodi"]