#!/bin/bash -eux
set -o pipefail

export DEBIAN_FRONTEND=noninteractive

echo 'kernel.core_pattern=%e-%t-SIG%s.core' >> /etc/sysctl.conf

apt-get clean \
&& rm -rf /var/lib/apt/lists \
&& apt-get -y -q update

apt-get -y -q install software-properties-common python-software-properties \
  openssh-server

apt-add-repository -y ppa:openjdk-r/ppa
apt-get -y -q update

apt-get -y -q install unzip xz-utils git libxml-xpath-perl wget curl
apt-get -y -q install default-jre openjdk-7-jdk openjdk-8-jdk

apt-get -y -q upgrade

update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac

update-ca-certificates -f
