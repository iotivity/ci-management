#!/bin/bash -eux
set -o pipefail

#IOTIVITYEXTLIB=${IOTIVITYEXTLIB:-/extlibs}
IOTIVITYEXTLIB=/extlibs

rm -rf ${WORKSPACE}/extlibs/arduino/arduino-1.5.8
rm -rf ${WORKSPACE}/extlibs/boost/boost_1_58_0
rm -rf ${WORKSPACE}/extlibs/boost/boost_1_58_0.zip
rm -rf ${WORKSPACE}/extlibs/cereal
rm -rf ${WORKSPACE}/extlibs/tinycbor/tinycbor
rm -rf ${WORKSPACE}/extlibs/gtest/gtest-1.7.0
rm -rf ${WORKSPACE}/extlibs/gtest/google-release-1.7.0
rm -rf ${WORKSPACE}/extlibs/hippomocks-master
rm -rf ${WORKSPACE}/extlibs/android/ndk/android-ndk-r10d
rm -rf ${WORKSPACE}/extlibs/android/sdk/android-sdk_r24.2
rm -rf ${WORKSPACE}/extlibs/android/gradle/gradle-2.2.1
rm -rf ${WORKSPACE}/extlibs/raxmpp/raxmpp
rm -rf ${WORKSPACE}/extlibs/libcoap/libcoap

if [ ! -d "${WORKSPACE}/extlibs/arduino" ]
then
	mkdir ${WORKSPACE}/extlibs/arduino
fi

if [ ! -d "${WORKSPACE}/extlibs/android" ]
then
	mkdir ${WORKSPACE}/extlibs/android
fi

if [ ! -d "${WORKSPACE}/extlibs/android/ndk" ]
then
	mkdir ${WORKSPACE}/extlibs/android/ndk
fi

if [ ! -d "${WORKSPACE}/extlibs/android/sdk" ]
then
	mkdir ${WORKSPACE}/extlibs/android/sdk
fi

if [ ! -d "${WORKSPACE}/extlibs/android/gradle" ]
then
	mkdir ${WORKSPACE}/extlibs/android/gradle
fi

if [ ! -d "${WORKSPACE}/extlibs/expat" ]
then
	mkdir ${WORKSPACE}/extlibs/expat
fi

if [ ! -d "${WORKSPACE}/extlibs/boost" ]
then
	mkdir ${WORKSPACE}/extlibs/boost
fi

if [ ! -d "${WORKSPACE}/extlibs/tinycbor" ]
then
	mkdir ${WORKSPACE}/extlibs/tinycbor
fi

if [ ! -d "${WORKSPACE}/extlibs/raxmpp" ]
then
	mkdir ${WORKSPACE}/extlibs/raxmpp
fi

if [ ! -d "${WORKSPACE}/extlibs/hippomocks-master" ]
then
        mkdir ${WORKSPACE}/extlibs/hippomocks-master
fi

ln -sv ${IOTIVITYEXTLIB}/arduino/arduino-1.5.8 ${WORKSPACE}/extlibs/arduino/arduino-1.5.8
if [ -d "${IOTIVITYEXTLIB}/boost/boost_1_58_0" ]
then
  ln -s "${IOTIVITYEXTLIB}/boost/boost_1_58_0" "${WORKSPACE}/extlibs/boost/"
else
  unzip -oq ${IOTIVITYEXTLIB}/boost/boost_1_58_0.zip -d ${WORKSPACE}/extlibs/boost/
fi
ln -sv ${IOTIVITYEXTLIB}/boost/boost_1_58_0.zip ${WORKSPACE}/extlibs/boost/boost_1_58_0.zip
ln -sv ${IOTIVITYEXTLIB}/cereal ${WORKSPACE}/extlibs/cereal

TINYCBOR_VERSION='0.5.1'
# always use the version that went through QA with each branch:
if [ "$GERRIT_BRANCH" = "1.3-rel" ]; then
    TINYCBOR_VERSION='0.4.1'
fi
if [ "$GERRIT_BRANCH" = "1.2-rel" ]; then
    TINYCBOR_VERSION='0.4'
fi
if [ "$GERRIT_BRANCH" = "1.1-rel" ]; then
    TINYCBOR_VERSION='0.2.1'
fi
if [ ! -f "${IOTIVITYEXTLIB}/tinycbor/v${TINYCBOR_VERSION}.zip" ]
then
  wget -O "${IOTIVITYEXTLIB}/tinycbor/v${TINYCBOR_VERSION}.zip" -nv "https://github.com/intel/tinycbor/archive/v${TINYCBOR_VERSION}.zip"
fi
unzip -oq "${IOTIVITYEXTLIB}/tinycbor/v${TINYCBOR_VERSION}.zip" -d ${IOTIVITYEXTLIB}/tinycbor/
ln -sv "${IOTIVITYEXTLIB}/tinycbor/tinycbor-${TINYCBOR_VERSION}" ${WORKSPACE}/extlibs/tinycbor/tinycbor

ln -sv ${IOTIVITYEXTLIB}/android/android-ndk-r10d.bin ${WORKSPACE}/extlibs/android/ndk/android-ndk-r10d
ln -sv ${IOTIVITYEXTLIB}/android/sdk/android-sdk_r24.2 ${WORKSPACE}/extlibs/android/sdk/android-sdk_r24.2
ln -sv ${IOTIVITYEXTLIB}/android/gradle/gradle-2.2.1 ${WORKSPACE}/extlibs/android/gradle/gradle-2.2.1
ln -sv ${IOTIVITYEXTLIB}/expat/expat-2.1.0 ${WORKSPACE}/extlibs/expat/expat-2.1.0
ln -sv ${IOTIVITYEXTLIB}/raxmpp/raxmpp ${WORKSPACE}/extlibs/raxmpp/raxmpp

HIPPOMOCKS_VERSION='5.0'
if [ ! -f "${IOTIVITYEXTLIB}/hippomocks/v${HIPPOMOCKS_VERSION}.zip" ]
then
  wget -O "${IOTIVITYEXTLIB}/hippomocks/v${HIPPOMOCKS_VERSION}.zip" -nv "https://github.com/dascandy/hippomocks/archive/v${HIPPOMOCKS_VERSION}.zip"
fi
unzip -oq "${IOTIVITYEXTLIB}/hippomocks/v${HIPPOMOCKS_VERSION}.zip" -d ${IOTIVITYEXTLIB}/hippomocks-master/
ln -sv ${IOTIVITYEXTLIB}/hippomocks-master ${WORKSPACE}/extlibs/hippomocks-master

RAPIDJSON_VERSION='1.0.2'
if [ ! -f "${IOTIVITYEXTLIB}/rapidjson/v${RAPIDJSON_VERSION}.zip" ]
then
  wget -O "${IOTIVITYEXTLIB}/rapidjson/v${RAPIDJSON_VERSION}.zip" -nv "https://github.com/miloyip/rapidjson/archive/v${RAPIDJSON_VERSION}.zip"
fi
unzip -oq "${IOTIVITYEXTLIB}/rapidjson/v${RAPIDJSON_VERSION}.zip" -d ${IOTIVITYEXTLIB}/rapidjson/
ln -sv ${IOTIVITYEXTLIB}/rapidjson ${WORKSPACE}/extlibs/rapidjson



if [ ! -d "${WORKSPACE}/extlibs/gtest" ]
then
	mkdir ${WORKSPACE}/extlibs/gtest
fi

ln -sv ${IOTIVITYEXTLIB}/gtest/gtest-1.7.0 ${WORKSPACE}/extlibs/gtest/gtest-1.7.0
ln -sv ${IOTIVITYEXTLIB}/gtest/gtest-1.7.0 ${WORKSPACE}/extlibs/gtest/google-release-1.7.0
#ln -sv ${IOTIVITYEXTLIB}/hippomocks-master ${WORKSPACE}/extlibs/hippomocks-master

if [ ! -d "${WORKSPACE}/extlibs/yaml" ]
then
	mkdir ${WORKSPACE}/extlibs/yaml
fi
ln -sv ${IOTIVITYEXTLIB}/yaml/yaml ${WORKSPACE}/extlibs/yaml/yaml

ln -sv ${IOTIVITYEXTLIB}/sqlite3/sqlite3.c ${WORKSPACE}/extlibs/sqlite3/sqlite3.c
ln -sv ${IOTIVITYEXTLIB}/sqlite3/sqlite3.h ${WORKSPACE}/extlibs/sqlite3/sqlite3.h

if [ ! -d "${WORKSPACE}/extlibs/mbedtls" ]
then
	mkdir ${WORKSPACE}/extlibs/mbedtls
fi
cp -R ${IOTIVITYEXTLIB}/mbedtls/mbedtls ${WORKSPACE}/extlibs/mbedtls/mbedtls

if [ ! -d "${WORKSPACE}/extlibs/libcoap" ]
then
	mkdir ${WORKSPACE}/extlibs/libcoap
fi
cp -R ${IOTIVITYEXTLIB}/libcoap/libcoap ${WORKSPACE}/extlibs/libcoap/libcoap
