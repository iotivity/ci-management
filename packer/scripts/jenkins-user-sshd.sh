#!/bin/bash -eux
set -o pipefail

# Create User
useradd -U -k /etc/skel -c "Jenkins User" -m jenkins-ci -d /home/jenkins-ci -s /bin/bash

# Download slave.jar
wget -nv 'https://build.iotivity.org/ci/jnlpJars/slave.jar' -O /home/jenkins-ci/slave.jar

mkdir /home/jenkins-ci/.ssh/

cat << EOF >> /home/jenkins-ci/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJ0naz6uZp9vXJNmYZjARvRWwRbY3vBWlFhmif+6O8SvKX/9Fmh63X4eGGgqcxi9sbZIM2oLIUwoSO/oPFWJddjYpmnvN1z009EWt11FzQVYKJ4QYBVzc1yuzWeGvVE4V51YXJBEXYTidGp/t3cRxduCUuAhYmhYMzp5q0iH9zS4KcNR5aY1bSGzYRKj09FL50DMdFRFaSG9iMSfCZwd1xfOa1SkgRbJJywTWtfbbIlQL1BFXrvTYN8IiwnDTmK60HXkaj6wVzGtqWTezfxJpB3V525nfYWmdVyPJ2bqsZvIHLS1HjymgvodRpXFbWbT9XIFtTVGCvdZqihrMfHI11 iotivity-jobbuilder
EOF

chmod 700 /home/jenkins-ci/.ssh
chmod 600 /home/jenkins-ci/.ssh/authorized_keys
