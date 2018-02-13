#!/bin/bash -ex
set -o pipefail

# Add Tizen tool repo, and install GBS
RELEASE=$(lsb_release -r | awk '{print $2}')

TIZEN_DEB_URL='http://download.tizen.org/tools/latest-release'

if [ $RELEASE == '16.04' ]
then

  TIZEN_DEB_URL="$TIZEN_DEB_URL/Ubuntu_16.04/"

elif [ $RELEASE == '12.04' ]
then

  TIZEN_DEB_URL="$TIZEN_DEB_URL/Ubuntu_12.04/"

fi
echo "deb $TIZEN_DEB_URL /" > /etc/apt/sources.list.d/tizen.list
apt-get -y update
apt-get -y install --force-yes gbs

# populate tizen package cache
mkdir /extlibs/GBS
curl https://moonunit.colliertech.org/~cjac/tmp/GBS.tar.bz2 | sudo tar -C /extlibs/GBS -xJ
