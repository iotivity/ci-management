#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

echo "installing ssh server"
& choco install -y openssh -params '"/SSHServerFeature"'
