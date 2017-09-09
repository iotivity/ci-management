#!/bin/bash -eux
set -o pipefail

# Create User
useradd -U -k /etc/skel -c "Jenkins User" -m jenkins-ci -d /home/jenkins-ci -s /bin/bash

# Download slave.jar
wget -nv 'https://build.iotivity.org/ci/jnlpJars/slave.jar' -O /home/jenkins-ci/slave.jar

mkdir /home/jenkins-ci/.ssh/

cat << EOF >> /home/jenkins-ci/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA7VhwOP6TYAFNf1muJbXMfVl00eFjBWgIW/8H09pyq10P6X7ss3U8M39lY5GHaVWyyH9nTPSJRM/CdPmgJhVswAJ3YEjVVkHz4Ni3xZKrb0Eeh4UlnN+iDta52vrRh+jFJNzxXmDauXH5GQzKcPsMW2zEimilWkRKJLWAQNaF1MXYrlFqvS1pfqgZlsSzGKgWwaoGTJZJkr/IZNVj/r7Y0I0S3Krzy0Hx3I5jQURXk+sIYfs0VLF+HlMVW7S83r5TEcMCVCCeQmhB5Lymt9dKSTBZITz6BsOu71Rxk5reZlexni2Eu+I98i6kbqGvr6qy/2lSo99eG0EZ5v9qqEtiRw== build.iotivity.org
EOF

chmod 700 /home/jenkins-ci/.ssh
chmod 600 /home/jenkins-ci/.ssh/authorized_keys
