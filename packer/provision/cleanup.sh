#!/bin/bash -eux
set -o pipefail

# Ensure Jenkins user has the required file permissions
chown -R jenkins-ci:jenkins-ci /home/jenkins-ci

if [ -d /extlibs/ ]; then
  chown -R jenkins-ci:jenkins-ci /extlibs/
fi
