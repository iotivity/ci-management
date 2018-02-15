#!/bin/bash -eux
set -o pipefail

if [ -e /swap ]
then
  swapoff /swap
  rm /swap
fi
