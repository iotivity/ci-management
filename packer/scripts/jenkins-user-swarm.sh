#!/bin/bash -eux
set -o pipefail

# Create User
useradd -U -k /etc/skel -c "Jenkins User" -m jenkins-ci -d /home/jenkins-ci -s /bin/bash

# Download Swarm
wget -nv 'https://repo.jenkins-ci.org/releases/org/jenkins-ci/plugins/swarm-client/2.2/swarm-client-2.2-jar-with-dependencies.jar' -O /home/jenkins-ci/swarm.jar

# Create Swarm Connection Script
cat << EOF >> /home/jenkins-ci/jenkins-swarm.sh
#! /bin/bash -ex

set -o pipefail

# Collect Metadata resources
curl -L -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/jenkins_labels > labels.txt

export JENKINS_USERNAME="\$(curl -L -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/jenkins_username)"
export JENKINS_PASSWORD="\$(curl -L -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/attributes/jenkins_api_token)"

# Connect to Jenkins
java -jar swarm-client-2.2-jar-with-dependencies.jar \
 -master http://build.iotivity.org:8080/ci/ \
 -executors 1 \
 -description "IoTivity Swarm Client" \
 -labelsFile labels.txt \
 -passwordEnvVariable JENKINS_PASSWORD \
 -mode exclusive \
 -name \$HOSTNAME \
 -username \$JENKINS_USERNAME 
EOF

chmod +x /home/jenkins-ci/jenkins-swarm.sh
