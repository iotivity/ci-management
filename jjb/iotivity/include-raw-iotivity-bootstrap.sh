#!/bin/bash -eux
set -o pipefail

#IOTIVITYEXTLIB=${IOTIVITYEXTLIB:-/extlibs}
IOTIVITYEXTLIB=/extlibs

for goner in arduino/arduino-1.5.8 \
             boost/boost_1_58_0 \
             boost/boost_1_58_0.zip \
             cereal \
             tinycbor/tinycbor \
             gtest/gtest-1.7.0 \
             gtest/google-release-1.7.0 \
             hippomocks-master \
             android/ndk/android-ndk-r10d \
             android/sdk/android-sdk_r24.2 \
             android/gradle/gradle-2.2.1 \
             raxmpp/raxmpp \
             libcoap/libcoap
do
  rm -rf ${WORKSPACE}/extlibs/${goner}
done

for extlib in arduino android android/ndk android/sdk android/gradle \
              expat boost tinycbor raxmpp rapidjson gtest yaml \
              mbedtls libcoap
do
  if [ ! -d "${WORKSPACE}/extlibs/${extlib}" ]
  then
        mkdir ${WORKSPACE}/extlibs/${extlib}
  fi
done

if [ -d "${IOTIVITYEXTLIB}/boost/boost_1_58_0" ]
then
  ln -s "${IOTIVITYEXTLIB}/boost/boost_1_58_0" "${WORKSPACE}/extlibs/boost/"
else
  unzip -oq ${IOTIVITYEXTLIB}/boost/boost_1_58_0.zip -d ${WORKSPACE}/extlibs/boost/
fi

TINYCBOR_VERSION='0.5.0'
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
  wget -O "${IOTIVITYEXTLIB}/tinycbor/v${TINYCBOR_VERSION}.zip" -nv "https://github.com/01org/tinycbor/archive/v${TINYCBOR_VERSION}.zip" 
fi
unzip -oq "${IOTIVITYEXTLIB}/tinycbor/v${TINYCBOR_VERSION}.zip" -d ${IOTIVITYEXTLIB}/tinycbor/
ln -sv "${IOTIVITYEXTLIB}/tinycbor/tinycbor-${TINYCBOR_VERSION}" ${WORKSPACE}/extlibs/tinycbor/tinycbor

ln -sv ${IOTIVITYEXTLIB}/android/android-ndk-r10d.bin ${WORKSPACE}/extlibs/android/ndk/android-ndk-r10d
ln -sv ${IOTIVITYEXTLIB}/gtest/gtest-1.7.0 ${WORKSPACE}/extlibs/gtest/google-release-1.7.0

for extlib in android/sdk/android-sdk_r24.2 \
              android/gradle/gradle-2.2.1 \
              expat/expat-2.1.0 \
              raxmpp/raxmpp \
              libstrophe/libstrophe \
              rapidjson/rapidjson \
              wksxmppxep/wksxmpp_chat \
              gtest/gtest-1.7.0 \
              hippomocks-master \
              arduino/arduino-1.5.8 \
              boost/boost_1_58_0.zip \
              cereal \
              yaml/yaml \
              sqlite3/sqlite3.c \
              sqlite3/sqlite3.h \
              mbedtls/mbedtls \
              libcoap/libcoap
do
  ln -sv ${IOTIVITYEXTLIB}/${extlib} ${WORKSPACE}/extlibs/${extlib}
done

