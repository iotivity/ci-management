#! /bin/bash -ex
set -o pipefail

mkdir -p /extlibs/

# Boost
# First dependency downloaded because it takes the longest. Hopefully
# this will change once sources are moved off of Sourceforge. Github's
# zipfile is not the same. The zip file is kept because the build system
# checks for it.

mkdir -p /extlibs/boost
cd /extlibs/boost
wget -nv https://storage.googleapis.com/iotivity/boost/boost_1_58_0.zip && unzip boost_1_58_0.zip

# Compile & Install Boost
cd /extlibs/boost/boost_1_58_0
./bootstrap.sh --with-libraries=system,filesystem,date_time,thread,regex,log,iostreams,program_options,atomic
./b2 -j4 install && ldconfig

# expat
mkdir -p /extlibs/expat
cd /extlibs/expat
wget -nv https://launchpad.net/ubuntu/+archive/primary/+files/expat_2.1.0.orig.tar.gz \
&& tar zxf expat_2.1.0.orig.tar.gz \
&& rm expat_2.1.0.orig.tar.gz

# gtest
mkdir -p /extlibs/gtest
cd /extlibs/gtest
wget -nv http://pkgs.fedoraproject.org/repo/pkgs/gtest/gtest-1.7.0.zip/2d6ec8ccdf5c46b05ba54a9fd1d130d7/gtest-1.7.0.zip \
&& unzip gtest-1.7.0.zip \
&& rm gtest-1.7.0.zip

# tinydtls - currently not used
#mkdir -p /extlibs/tinydtls
#cd /extlibs/tinydtls
#wget -nv 'http://downloads.sourceforge.net/project/tinydtls/r4/tinydtls-0.8.1.tar.gz' \
#&& tar zxf tinydtls-0.8.1.tar.gz \
#&& rm tinydtls-0.8.1.tar.gz

# sqlite
mkdir -p /extlibs/sqlite3/
cd /extlibs/sqlite3/
wget -nv 'http://www.sqlite.org/2015/sqlite-amalgamation-3081101.zip' \
&& unzip sqlite-amalgamation-3081101.zip \
&& mv sqlite-amalgamation-3081101/sqlite3.c . \
&& mv sqlite-amalgamation-3081101/sqlite3.h . \
&& rm -r sqlite-amalgamation-3081101 \
&& rm sqlite-amalgamation-3081101.zip

# tinycbor
mkdir -p /extlibs/tinycbor
cd /extlibs/tinycbor
tinycbor_pfx=https://github.com/intel/tinycbor/archive
for tinycbor_ver in 0.5.1 0.5.0 0.4.2 0.4.1 0.4 0.3.2 0.2.1
do
  wget -nv "${tinycbor_pfx}/v${tinycbor_ver}.zip"
done

cd /extlibs/

# libyaml
mkdir -p /extlibs/yaml
git clone https://github.com/jbeder/yaml-cpp.git /extlibs/yaml/yaml

# raxmpp
mkdir -p /extlibs/raxmpp
git clone https://gerrit.iotivity.org/gerrit/iotivity-xmpp /extlibs/raxmpp/raxmpp

# hippomocks
git clone https://github.com/dascandy/hippomocks /extlibs/hippomocks-master \
&& cd /extlibs/hippomocks-master \
&& git checkout -qf 2f40aa11e31499432283b67f9d3449a3cd7b9c4d

# mbedtls
mkdir -p /extlibs/mbedtls
git clone https://github.com/ARMmbed/mbedtls /extlibs/mbedtls/mbedtls \
&& cd /extlibs/mbedtls/mbedtls \
&& git fetch --all --tags \
&& echo "59ae96f167a19f4d04dc6db61f6587b37ccd429f" > .git/refs/tags/mbedtls-2.4.2

# libcoap
mkdir -p /extlibs/libcoap
git clone https://github.com/dthaler/libcoap /extlibs/libcoap/libcoap \
&& cd /extlibs/libcoap/libcoap \
&& git fetch --all --tags \
&& git checkout tags/IoTivity-1.4
