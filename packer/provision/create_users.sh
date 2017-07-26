#!/bin/bash
# @License EPL-1.0 <http://spdx.org/licenses/EPL-1.0>
##############################################################################
# Copyright (c) 2016,2017 The Linux Foundation and others.
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
#OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')

os_username="${OS}"
os_groupname="${OS}"

ci_username="jenkins-ci"
ci_groupname="jenkins-ci"

# Create User
useradd -U -k /etc/skel -c "Jenkins User" -m jenkins-ci -d /home/jenkins-ci -s /bin/bash
#useradd -m -s /bin/bash ${ci_username}

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
os_pubkeys="/home/${os_username}/.ssh/authorized_keys"

mkdir -p /home/${ci_username}/.ssh/
mkdir -p /home/${os_username}/.ssh/

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCld6N4H5SI5TxrKdZcXeI22Y+mPtiiFjP7y788dt8WN0KLaZZAJjeoUOq7qJGWqW3NUEXyzqeAxK0TIURjCHrnBA7vQm4wMZw22uvl/ZINx69ccxKya3NaY2KOMdSdczAJeZWj68o9n9Dzpj+kd1Qnt3xEIJGgdgYCgmnCrt5QAp8vnkzM+DVl38eCGzw4IwCo1ex6MwD0dwNzkDzeHD0YBneL7MY7klwB+7OSxgD/Wym0qNUNt446L8EZnMRJt9KjBEi1p6DGQGufUKQk1qqZC4e3u1AuS8O7HQP4khUNvNN14qpurtarUOEo9Ifveqkg2boZiBpklJ5Q70sgrN/Z ${ci_username}" >> "${ci_pubkeys}"

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJ0naz6uZp9vXJNmYZjARvRWwRbY3vBWlFhmif+6O8SvKX/9Fmh63X4eGGgqcxi9sbZIM2oLIUwoSO/oPFWJddjYpmnvN1z009EWt11FzQVYKJ4QYBVzc1yuzWeGvVE4V51YXJBEXYTidGp/t3cRxduCUuAhYmhYMzp5q0iH9zS4KcNR5aY1bSGzYRKj09FL50DMdFRFaSG9iMSfCZwd1xfOa1SkgRbJJywTWtfbbIlQL1BFXrvTYN8IiwnDTmK60HXkaj6wVzGtqWTezfxJpB3V525nfYWmdVyPJ2bqsZvIHLS1HjymgvodRpXFbWbT9XIFtTVGCvdZqihrMfHI11 iotivity-jobbuilder" >> "${os_pubkeys}"
cat "${os_pubkeys}" >> "${ci_pubkeys}"

# Generate ssh key for use by Robot jobs
echo -e 'y\n' | ssh-keygen -N "" -f /home/${ci_username}/.ssh/id_rsa -t rsa

# set password for ubuntu user
#usermod -p '$6$WmC4QVis$4SxluIFMVCKqvJws7BYW7gRy0L4aK4f./fNZXrw8/3/jnEtfccp.02bGi5FS41oZKWmpXLRfLJtaYd1X.rGj/0' "${os_user}"

perl -pi -e 's{^ubuntu:.+?:}{ubuntu:\Q$6$WmC4QVis$4SxluIFMVCKqvJws7BYW7gRy0L4aK4f./fNZXrw8/3/jnEtfccp.02bGi5FS41oZKWmpXLRfLJtaYd1X.rGj/0\E:}' /etc/shadow
#perl -pi -e 's{^$ARGV[0]:.+?:}{$ARGV[0]:\Q$6$WmC4QVis$4SxluIFMVCKqvJws7BYW7gRy0L4aK4f./fNZXrw8/3/jnEtfccp.02bGi5FS41oZKWmpXLRfLJtaYd1X.rGj/0\E:}' /etc/shadow "${os_user}"

# allow password authentication
perl -pi -e 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config



# Download slave.jar
wget -nv 'https://jenkins.iotivity.org/ci/jnlpJars/slave.jar' -O /home/jenkins-ci/slave.jar


cat << EOF >> /home/jenkins-ci/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJKWRPbQaCVukxGxE2A5EyJfjqqRPWztq7xNUdUewPipDIULixh5+TZdBDrlGJGGxL8Pom2INsV7VO4I++eiy71eiSdt4oZJCbdATvSV+OeSP6ZvK5lnrlhcAG2CUum6fxVIGDhsRXG3yN2EafabNaKXV594pCYZeaAMQ9ycBlOOxoidpCUifUHFKUQNq2sELeEP5N/JYAAJ16rL+kIVAQ2MBX7zBAFXJwCWto+yQcRyB+NAJ7wr8PniJcyjg1vKDK8qtIQemtM4HtiqA3BSpfbYpLazx4vk52SDOeSjCrmbIPQdRhVLrDp1irOHKzT7BQBBA/1LevXjEexv0HIhHN
EOF

cat << EOF >> /home/jenkins-ci/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJKWRPbQaCVukxGxE2A5EyJfjqqRPWztq7xNUdUewPipDIULixh5+TZdBDrlGJGGxL8Pom2INsV7VO4I++eiy71eiSdt4oZJCbdATvSV+OeSP6ZvK5lnrlhcAG2CUum6fxVIGDhsRXG3yN2EafabNaKXV594pCYZeaAMQ9ycBlOOxoidpCUifUHFKUQNq2sELeEP5N/JYAAJ16rL+kIVAQ2MBX7zBAFXJwCWto+yQcRyB+NAJ7wr8PniJcyjg1vKDK8qtIQemtM4HtiqA3BSpfbYpLazx4vk52SDOeSjCrmbIPQdRhVLrDp1irOHKzT7BQBBA/1LevXjEexv0HIhHN
EOF

chmod 700 /home/${ci_username}/.ssh
chmod 600 /home/${ci_username}/.ssh/authorized_keys

chmod 700 /home/${os_username}/.ssh
chmod 600 /home/${os_username}/.ssh/authorized_keys

mkdir /w
chown -R ${ci_username}:${ci_groupname} /home/${ci_username}/.ssh /w
chown -R ${os_username}:${os_groupname} /home/${os_username}/.ssh
