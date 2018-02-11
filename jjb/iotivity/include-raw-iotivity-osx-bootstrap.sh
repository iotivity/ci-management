#!/bin/bash -eux
set -o pipefail
PATH=$PATH:/usr/local/bin/
IOTIVITYEXTLIB=/Users/jenkins-ci/extlibs
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

# tinycbor
unzip -oq "${IOTIVITYEXTLIB}/tinycbor/v${TINYCBOR_VERSION}.zip" -d ${IOTIVITYEXTLIB}/tinycbor/
ln -s "${IOTIVITYEXTLIB}/tinycbor/tinycbor-${TINYCBOR_VERSION}" ${WORKSPACE}/extlibs/tinycbor/tinycbor
# gtest
unzip -oq ${IOTIVITYEXTLIB}/gtest/gtest-1.7.0.zip -d ${WORKSPACE}/extlibs/gtest
ln -s ${IOTIVITYEXTLIB}/gtest/gtest-1.7.0.zip ${WORKSPACE}/extlibs/gtest/gtest-1.7.0.zip
ln -s ${IOTIVITYEXTLIB}/gtest/release-1.7.0.zip ${WORKSPACE}/extlibs/gtest/release-1.7.0.zip
# mbedtls
mkdir -p ${WORKSPACE}/extlibs/mbedtls
cp -r ${IOTIVITYEXTLIB}/mbedtls/mbedtls ${WORKSPACE}/extlibs/mbedtls/mbedtls
# libcoap
mkdir -p ${WORKSPACE}/extlibs/libcoap
cp -r ${IOTIVITYEXTLIB}/libcoap/libcoap ${WORKSPACE}/extlibs/libcoap/libcoap
