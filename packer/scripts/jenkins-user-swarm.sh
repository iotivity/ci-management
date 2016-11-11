#!/bin/bash -eux
set -o pipefail

# Create User
useradd -U -k /etc/skel -c "Jenkins User" -m jenkins-ci -d /home/jenkins-ci -s /bin/bash

# Create Swarm Init Script
cat << EOF >> /etc/init/jenkins-ci.conf
# jenkins-ci - Jenkins Swarm Client
#
# This service starts the Jenkins Swarm agent once the metadata server
# is available

description "Jenkins Swarm Client"

start on filesystem or runlevel [2345]
stop on runlevel [!2345]

respawn
respawn limit 10 5

env user=jenkins-ci
env cmd=/home/jenkins-ci/jenkins-swarm.sh
env HOME=/home/jenkins-ci

exec su -s /bin/sh -c 'exec "\$0" "\$@"' \$user -- \$cmd
EOF

# Download Swarm
wget -nv 'https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.2/swarm-client-2.2-jar-with-dependencies.jar' -O /home/jenkins-ci/swarm.jar

# Create Swarm Connection Script
cat << EOF >> /home/jenkins-ci/jenkins-swarm.sh
#! /bin/bash -e

set -o pipefail

# Collect Metadata resources
export JENKINS_LABELS="\$(curl -sL -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/jenkins_labels)"
export JENKINS_HOSTNAME="\$(curl -sL -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/jenkins_hostname)"
export JENKINS_USERNAME="\$(curl -sL -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/jenkins_username)"
export JENKINS_PASSWORD="\$(curl -sL -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/jenkins_api_token)"

# Connect to Jenkins
java -jar \$HOME/swarm.jar \
 -master http://\$JENKINS_HOSTNAME:8080/ci/ \
 -executors 1 \
 -description "IoTivity Swarm Client" \
 -labels \$JENKINS_LABELS \
 -passwordEnvVariable JENKINS_PASSWORD \
 -mode exclusive \
 -fsroot \$HOME \
 -name \$HOSTNAME \
 -username \$JENKINS_USERNAME
EOF

chmod +x /home/jenkins-ci/jenkins-swarm.sh
