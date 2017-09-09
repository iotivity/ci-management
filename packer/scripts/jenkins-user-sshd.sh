#!/bin/bash -eux
set -o pipefail

# Create User
useradd -U -k /etc/skel -c "Jenkins User" -m jenkins-ci -d /home/jenkins-ci -s /bin/bash

# Download slave.jar
wget -nv 'https://build.iotivity.org/ci/jnlpJars/slave.jar' -O /home/jenkins-ci/slave.jar

mkdir /home/jenkins-ci/.ssh/

cat << EOF >> /home/jenkins-ci/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJKWRPbQaCVukxGxE2A5EyJfjqqRPWztq7xNUdUewPipDIULixh5+TZdBDrlGJGGxL8Pom2INsV7VO4I++eiy71eiSdt4oZJCbdATvSV+OeSP6ZvK5lnrlhcAG2CUum6fxVIGDhsRXG3yN2EafabNaKXV594pCYZeaAMQ9ycBlOOxoidpCUifUHFKUQNq2sELeEP5N/JYAAJ16rL+kIVAQ2MBX7zBAFXJwCWto+yQcRyB+NAJ7wr8PniJcyjg1vKDK8qtIQemtM4HtiqA3BSpfbYpLazx4vk52SDOeSjCrmbIPQdRhVLrDp1irOHKzT7BQBBA/1LevXjEexv0HIhHN
EOF

chmod 700 /home/jenkins-ci/.ssh
chmod 600 /home/jenkins-ci/.ssh/authorized_keys
