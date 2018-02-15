#!/bin/bash -eux
set -o pipefail

if [ -e /swap ]
then
  swapoff /swap
  rm /swap
fi

ci_username='jenkins'
ci_groupname='jenkins'

# Ensure Jenkins user has the required file permissions
chown -R ${ci_username}:${ci_groupname} /home/${ci_username}

if [ -d /extlibs/ ]; then
  chown -R ${ci_username}:${ci_groupname} /extlibs/
fi
