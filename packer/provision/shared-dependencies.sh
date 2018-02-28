#! /bin/bash -ex
set -o pipefail

#IOTIVITYEXTLIB=${IOTIVITYEXTLIB:-/extlibs}
IOTIVITYEXTLIB=/extlibs

mkdir -p "${IOTIVITYEXTLIB}"/

# Boost
# First dependency downloaded because it takes the longest. Hopefully
# this will change once sources are moved off of Sourceforge. Github's
# zipfile is not the same. The zip file is kept because the build system
# checks for it.

mkdir -p "${IOTIVITYEXTLIB}"/boost
cd "${IOTIVITYEXTLIB}"/boost
wget -nv https://storage.googleapis.com/iotivity/boost/boost_1_58_0.zip && unzip boost_1_58_0.zip

# boost compilation fails on a 1G system so workaround that with a swap file
echo "creating swap file"
# Compile & Install Boost
if [ ! -e /swap ]
then
  echo "enabling swap"
  dd if=/dev/zero of=/swap bs=1M count=4096
  chmod 0600 /swap
  mkswap /swap
  swapon /swap
fi

cd "${IOTIVITYEXTLIB}"/boost/boost_1_58_0
./bootstrap.sh --with-libraries=system,filesystem,date_time,thread,regex,log,iostreams,program_options,atomic
./b2 -j4 install && ldconfig

# expat
mkdir -p "${IOTIVITYEXTLIB}"/expat
cd "${IOTIVITYEXTLIB}"/expat
wget -nv https://launchpad.net/ubuntu/+archive/primary/+files/expat_2.1.0.orig.tar.gz \
&& tar zxf expat_2.1.0.orig.tar.gz \
&& rm expat_2.1.0.orig.tar.gz

# gtest
mkdir -p "${IOTIVITYEXTLIB}"/gtest
cd "${IOTIVITYEXTLIB}"/gtest
for version in 1.7.0 1.8.0
do
  wget -nv -O "gtest-${version}.zip" "https://github.com/google/googletest/archive/release-${version}.zip" \
  && unzip "gtest-${version}.zip"
done

# tinydtls - currently not used
#mkdir -p "${IOTIVITYEXTLIB}"/tinydtls
#cd "${IOTIVITYEXTLIB}"/tinydtls
#wget -nv 'http://downloads.sourceforge.net/project/tinydtls/r4/tinydtls-0.8.1.tar.gz' \
#&& tar zxf tinydtls-0.8.1.tar.gz \
#&& rm tinydtls-0.8.1.tar.gz

# sqlite
mkdir -p "${IOTIVITYEXTLIB}"/sqlite3/
cd "${IOTIVITYEXTLIB}"/sqlite3/
wget -nv 'http://www.sqlite.org/2015/sqlite-amalgamation-3081101.zip' \
&& unzip sqlite-amalgamation-3081101.zip \
&& mv sqlite-amalgamation-3081101/sqlite3.c . \
&& mv sqlite-amalgamation-3081101/sqlite3.h . \
&& rm -r sqlite-amalgamation-3081101 \
&& rm sqlite-amalgamation-3081101.zip

# tinycbor
mkdir -p "${IOTIVITYEXTLIB}"/tinycbor
cd "${IOTIVITYEXTLIB}"/tinycbor
tinycbor_pfx=https://github.com/01org/tinycbor/archive
for tinycbor_ver in 0.5.0 0.4.2 0.4.1 0.4 0.3.2 0.2.1
do
  wget -nv "${tinycbor_pfx}/v${tinycbor_ver}.zip"
done

cd "${IOTIVITYEXTLIB}"/

# libyaml
mkdir -p "${IOTIVITYEXTLIB}"/yaml
git clone https://github.com/jbeder/yaml-cpp.git "${IOTIVITYEXTLIB}"/yaml/yaml

# raxmpp
mkdir -p "${IOTIVITYEXTLIB}"/raxmpp
git clone https://gerrit.iotivity.org/gerrit/iotivity-xmpp "${IOTIVITYEXTLIB}"/raxmpp/raxmpp

# hippomocks
git clone https://github.com/dascandy/hippomocks "${IOTIVITYEXTLIB}"/hippomocks-master \
&& cd "${IOTIVITYEXTLIB}"/hippomocks-master \
&& git checkout -qf 2f40aa11e31499432283b67f9d3449a3cd7b9c4d

# mbedtls
mkdir -p "${IOTIVITYEXTLIB}"/mbedtls
git clone https://github.com/ARMmbed/mbedtls "${IOTIVITYEXTLIB}"/mbedtls/mbedtls \
&& cd "${IOTIVITYEXTLIB}"/mbedtls/mbedtls \
&& git fetch --all --tags \
&& echo "59ae96f167a19f4d04dc6db61f6587b37ccd429f" > .git/refs/tags/mbedtls-2.4.2

# libcoap
mkdir -p "${IOTIVITYEXTLIB}"/libcoap
git clone https://github.com/dthaler/libcoap "${IOTIVITYEXTLIB}"/libcoap/libcoap \
&& cd "${IOTIVITYEXTLIB}"/libcoap/libcoap \
&& git fetch --all --tags \
&& git checkout tags/IoTivity-1.2.1

# source of gerrit projects
mkdir "${IOTIVITYEXTLIB}/gerrit"
for project in iotivity iotivity-alljoyn-bridge iotivity-constrained \
               iotivity-contrib iotivity-node iotivity-test iotivity-upnp-bridge \
               iotivity-voice iotivity-xmpp
do
  git clone "https://gerrit.iotivity.org/gerrit/p/$project.git" "${IOTIVITYEXTLIB}/gerrit/$project"
done
