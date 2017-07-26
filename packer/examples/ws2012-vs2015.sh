#!/bin/bash

# This script installs visual studio 2015 to a windows server 2012
# packer image based on the cloudbase-init evaluation image

set -e

# https://www.packer.io/docs/builders/openstack.html

mkdir -p temp log

OS=ws2012
TOOLCHAIN=vs2015
TEMPLATE=baseline

TMPDIR=./temp
export PACKER_LOG=1
TS=$(date +"%Y%m%dT%H%M%S")
export PACKER_LOG_PATH="${PWD}/log/packer-${OS}-${TOOLCHAIN}-${TS}.log"

${HOME}/bin/packer build   \
  -var-file=vars/cloud-env.json   \
  -var-file=vars/${OS}-${TOOLCHAIN}.json   \
  templates/visual-studio.json

unset -v TS
