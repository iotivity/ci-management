#! /bin/bash -ex
set -o pipefail

# blcr-util
# dos2unix
# ttf-dejavu-core
# traceroute
# gccxml
# libcr0
# libopenmpi-dev
# libstdc++6-4.6-dev
# libtorque2
# mpi-default-bin
# mpi-default-dev
# openmpi-bin
# openmpi-common
# python-http-parser
# scons
# htop
# libstdc++6-4.7-dev



COMMON_PKGS="autoconf
autotools-dev
binutils
blcr-util
build-essential
ca-certificates-java
cmap-adobe-japan1
cpp
doc-base
dos2unix
dpkg-dev
fakeroot
fontconfig
fontconfig-config
fonts-liberation
g++
gcc
gccxml
gdb
gettext
git
graphviz
gs-cjk-resource
gsfonts
installation-report
intltool-debian
java-common
language-pack-en
language-pack-en-base
lib32gcc1
lib32stdc++6
lib32z1
libalgorithm-diff-perl
libalgorithm-diff-xs-perl
libalgorithm-merge-perl
libasyncns0
libavahi-client3
libavahi-common-data
libavahi-common3
libbz2-dev
libc-dev-bin
libc6-dbg
libc6-dev
libc6-i386
libcairo2
libcr0
libcroco3
libcups2
libcupsimage2
libdatrie1
libdpkg-perl
liberror-perl
libexpat1-dev
libffi-dev
libflac8
libfontconfig1
libfontenc1
libgettextpo0
libglib2.0-bin
libglib2.0-data
libglib2.0-dev
libgomp1
libgs9
libgs9-common
libibverbs-dev
libibverbs1
libice6
libicu-dev
libijs-0.35
libjasper1
libjbig2dec0
libjpeg-turbo8
libjpeg8
libjson0
liblcms2-2
liblua5.1-0
libmail-sendmail-perl
libmpfr4
libnspr4
libnss3
libnss3-1d
libnuma1
libogg0
libpango1.0-0
libpaper-utils
libpaper1
libpathplan4
libpcre3-dev
libpixman-1-0
libpulse0
libquadmath0
libsensors4
libsm6
libsndfile1
libssl-dev
libssl-doc
libsqlite3-dev
libsys-hostname-long-perl
libthai-data
libthai0
libtool
libtorque2
libunistring0
libuuid-perl
libvorbis0a
libvorbisenc2
libxaw7
libxcb-render0
libxcb-shm0
libxfont1
libxft2
libxmu6
libxpm4
libxrender1
libxt6
libyaml-tiny-perl
linux-libc-dev
make
mpi-default-bin
mpi-default-dev
openmpi-bin
openmpi-common
pkg-config
po-debconf
ps2eps
python-dev
python-http-parser
python2.7-dev
scons
sysstat
traceroute
unzip
uuid-dev
valgrind
vim
xfonts-encodings
xfonts-utils
zlib1g-dev
libcurl4-openssl-dev
htop
wget"

PKG_LIST=$COMMON_PKGS

RELEASE=$(lsb_release -r | awk '{print $2}')

if [ $RELEASE == '16.04' ]
then

  XENIAL_PKGS="g++-5
gcc-6-base
libgvc6
libgvpr2
libpcrecpp0v5
libstdc++6-4.7-dev
libopenmpi1.10
cpp-5
libcdt5
libcgraph6
libgd3
libicu55
libkpathsea6
libmpc3
libpoppler58
libtiff5
fonts-dejavu-core"

  PKG_LIST="$PKG_LIST $XENIAL_PKGS"

  dpkg --add-architecture i386
  add-apt-repository universe

  find /etc/apt/ -name '*.list' | xargs perl -pi -e 's{ubuntu.mirror.vexxhost.com}{mirrors.kernel.org}g' 


elif [ $RELEASE == '12.04' ]
then
  PRECISE_PKGS="g++-4.6
gcc-4.6
ia32-libs
libgvc5
libgvpr1
libopenmpi1.3
libpcrecpp0
libstdc++6-4.6-dev
openmpi-checkpoint
tzdata-java
cpp-4.6
libcdt4
libcgraph5
libgd2-xpm
libgraph4
libicu48
libkpathsea5
libmpc2
libpoppler19
libtiff4
ttf-liberation
ttf-dejavu-core
libopenmpi-dev
"

  PKG_LIST="$PKG_LIST $PRECISE_PKGS"
fi

apt-get update

apt-get -y -q install ${PKG_LIST}

## These may be all the files required
##apt-get -y install \
##  autotools-dev \
##  dpkg-dev \
##  libbz2-dev \
##  libc-dev-bin \
##  libc6-dev \
##  libexpat1-dev \
##  libffi-dev \
##  libglib2.0-dev \
##  libibverbs-dev \
##  libicu-dev \
##  libopenmpi-dev \
##  libpcre3-dev \
##  libssl-dev \
##  libstdc++6-4.6-dev \
##  linux-libc-dev \
##  mpi-default-dev \
##  python-dev \
##  python2.7-dev \
##  uuid-dev \
##  zlib1g-dev \
##  libcurl4-openssl-dev
