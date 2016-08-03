#!/bin/bash -eux
set -o pipefail

# Create User
useradd -U -k /etc/skel -c "Jenkins User" -m jenkins-ci -d /home/jenkins-ci -s /bin/bash

# Download slave.jar
wget -nv 'https://build.iotivity.org/ci/jnlpJars/slave.jar' -O /home/jenkins-ci/slave.jar

cat << EOF >> /home/jenkins-ci/jenkins-jnlp.sh
#!/bin/bash

exec java -cp /home/jenkins-ci/slave.jar hudson.remoting.jnlp.Main -headless -url \$JENKINS_URL "\$@"
EOF

chmod +x /home/jenkins-ci/jenkins-jnlp.sh
