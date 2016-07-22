#!/bin/bash -eux
set -o pipefail
PATH=$PATH:/usr/local/bin/
IOTIVITYEXTLIB=/Users/jenkins-ci/extlibs
TINYCBOR_VERSION='0.2.1'

unzip -oq "${IOTIVITYEXTLIB}/tinycbor/v${TINYCBOR_VERSION}.zip" -d ${IOTIVITYEXTLIB}/tinycbor/
ln -s "/Users/jenkins-ci/extlibs/tinycbor/tinycbor-${TINYCBOR_VERSION}" $WORKSPACE/extlibs/tinycbor/tinycbor
