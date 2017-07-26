#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

echo "removing password expiry"
& C:\packer\unlimited-password-expiration.bat
echo "enabling RDP"
& C:\packer\enable-rdp.bat
echo "disabling UAC"
& C:\packer\uac-disable.bat
echo "disabling hibernate"
& C:\packer\disable-hibernate.bat
echo "fetching CURL"
& C:\packer\fetch-curl.ps1
echo "fetching vs2015"
& C:\packer\fetch-vs2015.ps1
#echo "fetching PSWindowsUpdate"
#& C:\packer\install-PSWindowsUpdate.ps1
#echo "updating windows"
#& C:\packer\windows-update.ps1
echo "Installing vs2015"
& C:\packer\install-vs2015.ps1
#echo "disabling windows update"
#& C:\packer\disablewinupdate.bat


