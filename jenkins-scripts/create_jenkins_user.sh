#!/bin/bash
# @License EPL-1.0 <http://spdx.org/licenses/EPL-1.0>
##############################################################################
# Copyright (c) 2016 The Linux Foundation and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License v1.0
# which accompanies this distribution, and is available at
# http://www.eclipse.org/legal/epl-v10.html
##############################################################################

#######################
# Create Jenkins User #
#######################

OS=$(facter operatingsystem | tr '[:upper:]' '[:lower:]')
ci_username="jenkins"
ci_groupname="jenkins"

useradd -m -s /bin/bash ${ci_username}

# Check if docker group exists
grep -q docker /etc/group
if [ "$?" == '0' ]
then
  # Add jenkins user to docker group
  usermod -a -G docker ${ci_username}
fi

# Check if mock group exists
grep -q mock /etc/group
if [ "$?" == '0' ]
then
  # Add jenkins user to mock group so they can build Int/Pack's RPMs
  usermod -a -G mock ${ci_username}
fi

ci_pubkeys="/home/${ci_username}/.ssh/authorized_keys"

mkdir /home/${ci_username}/.ssh
mkdir /w
cp -r /home/${OS}/.ssh/authorized_keys ${ci_pubkeys}

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCld6N4H5SI5TxrKdZcXeI22Y+mPtiiFjP7y788dt8WN0KLaZZAJjeoUOq7qJGWqW3NUEXyzqeAxK0TIURjCHrnBA7vQm4wMZw22uvl/ZINx69ccxKya3NaY2KOMdSdczAJeZWj68o9n9Dzpj+kd1Qnt3xEIJGgdgYCgmnCrt5QAp8vnkzM+DVl38eCGzw4IwCo1ex6MwD0dwNzkDzeHD0YBneL7MY7klwB+7OSxgD/Wym0qNUNt446L8EZnMRJt9KjBEi1p6DGQGufUKQk1qqZC4e3u1AuS8O7HQP4khUNvNN14qpurtarUOEo9Ifveqkg2boZiBpklJ5Q70sgrN/Z ${ci_username}" >> "${ci_pubkeys}"

# Generate ssh key for use by Robot jobs
echo -e 'y\n' | ssh-keygen -N "" -f /home/jenkins/.ssh/id_rsa -t rsa

chmod 700 /home/${ci_username}/.ssh
chmod 600 ${ci_pubkeys}

chown -R ${ci_username}:${ci_groupname} /home/${ci_username}/.ssh /w /extlibs

dd if=/dev/zero of=/swap bs=1M count=16384
mkswap /swap
swapon /swap
