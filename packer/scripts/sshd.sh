#!/bin/bash -eux
set -o pipefail

mkdir /var/run/sshd/

cat << EOF > /etc/ssh/sshd_config
Port 22
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
UsePrivilegeSeparation yes
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 90
PermitRootLogin no
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
ChallengeResponseAuthentication no
PasswordAuthentication no
X11Forwarding no
PrintMotd no
AcceptEnv LANG LC_*
UsePAM yes
EOF
