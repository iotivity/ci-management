#!/bin/bash -ex
set -o pipefail

# Add Tizen tool repo, and install GBS
echo 'deb http://download.tizen.org/tools/latest-release/Ubuntu_12.04 /' > /etc/apt/sources.list.d/tizen.list
apt-get -y update
apt-get -y install --force-yes gbs
