#!/bin/bash

# This script installs visual studio 2017 to a windows server 2016
# packer image based on the VexxHost Windows image

set -e

# https://www.packer.io/docs/builders/qemu.html

mkdir -p temp log

OS=ws2016
TOOLCHAIN=vs2017
TEMPLATE=baseline

TMPDIR=./temp
export PACKER_LOG=1
TS=$(date +"%Y%m%dT%H%M%S")
export PACKER_LOG_PATH="${PWD}/log/packer-${OS}-${TOOLCHAIN}-${TS}.log"

${HOME}/bin/packer build   \
  -var-file=vars/cloud-env.json   \
  -var-file=vars/${OS}-${TOOLCHAIN}.json   \
  templates/windows/visual-studio.json

unset -v TS
