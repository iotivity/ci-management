#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

echo "disabling windows update"
& C:\packer\disablewinupdate.bat

echo "installing ssh server"
& choco install -y openssh -params '"/SSHServerFeature"'

echo "removing password expiry"
& C:\packer\unlimited-password-expiration.bat

echo "enabling RDP"
& C:\packer\enable-rdp.bat

echo "disabling UAC"
& C:\packer\uac-disable.bat

echo "disabling hibernate"
& C:\packer\disable-hibernate.bat
