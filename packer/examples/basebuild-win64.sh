#!/bin/bash

set -e

# https://www.packer.io/docs/builders/qemu.html

#perl gen-packer.pl > packer.json

mkdir -p temp log

TMPDIR=./temp
export PACKER_LOG=1
TS=$(date +"%Y%m%dT%H%M%S")
export PACKER_LOG_PATH="${PWD}/log/packer-win-basebuild-amd64-${TS}.log"

${HOME}/bin/packer build   \
  -var-file=vars/cloud-env.json   \
  -var-file=vars/windows-server-2012-amd64-basebuild.json   \
  templates/basebuild-win.json

unset -v TS
