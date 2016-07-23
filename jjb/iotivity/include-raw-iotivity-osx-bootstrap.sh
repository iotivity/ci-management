#!/bin/bash -eux
set -o pipefail
PATH=$PATH:/usr/local/bin/
IOTIVITYEXTLIB=/Users/jenkins-ci/extlibs
TINYCBOR_VERSION='0.2.1'

unzip -oq "${IOTIVITYEXTLIB}/tinycbor/v${TINYCBOR_VERSION}.zip" -d ${IOTIVITYEXTLIB}/tinycbor/
ln -s "${IOTIVITYEXTLIB}/tinycbor/tinycbor-${TINYCBOR_VERSION}" ${WORKSPACE}/extlibs/tinycbor/tinycbor
unzip -oq ${IOTIVITYEXTLIB}/gtest/gtest-1.7.0.zip -d ${WORKSPACE}/extlibs/gtest
ln -s "${IOTIVITYEXTLIB}/gtest/gtest-1.7.0.zip ${WORKSPACE}/extlibs/gtest/gtest-1.7.0.zip
