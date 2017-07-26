#!/bin/bash -eux
set -o pipefail

if [ -e /swap ]
then
  swapoff /swap
  rm /swap
fi

# Ensure Jenkins user has the required file permissions
chown -R jenkins-ci:jenkins-ci /home/jenkins-ci

if [ -d /extlibs/ ]; then
  chown -R jenkins-ci:jenkins-ci /extlibs/
fi
