#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

Invoke-Item "C:\packer\unlimited-password-expiration.bat"
Invoke-Item "C:\packer\enable-rdp.bat"
Invoke-Item "C:\packer\uac-disable.bat"
Invoke-Item "C:\packer\disablewinupdate.bat"
Invoke-Item "C:\packer\disable-hibernate.bat"

