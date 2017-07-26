#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

echo "fetching cURL"
& C:\packer\fetch-curl.ps1

#echo "fetching PSWindowsUpdate"
#& C:\packer\install-PSWindowsUpdate.ps1
#echo "updating windows"
#$cred = get-credential
#Invoke-Command -ComputerName localhost -credential $cred -scriptblock {& C:\packer\win-updates.ps1}
#& C:\packer\windows-update.ps1

echo "connect to system console and perform windows update now."
echo "When finished, create a file $HOME\AppData\Local\Temp\update-done.txt"

$slept = 0
Get-Date -f u
do {
  sleep 5
  $slept += 5
  Write-Host -NoNewline "."
} while(![System.IO.File]::Exists("$HOME\AppData\Local\Temp\update-done.txt"))
rm $HOME\AppData\Local\Temp\update-done.txt
echo "Done"
Get-Date -f u

echo "removing password expiry"
& C:\packer\unlimited-password-expiration.bat
echo "enabling RDP"
& C:\packer\enable-rdp.bat
echo "disabling UAC"
& C:\packer\uac-disable.bat
echo "disabling hibernate"
& C:\packer\disable-hibernate.bat
echo "fetching vs2015"
& C:\packer\fetch-vs2015.ps1

echo "Installing vs2015"
& C:\packer\install-vs2015.ps1
echo "disabling windows update"
& C:\packer\disablewinupdate.bat

# Other dependencies

# Install boost_1_60_0.zip
# 	  googletest-release-1.7.0.zip
#	  gtest-1.7.0.zip
# https://codeload.github.com/google/googletest/zip/release-1.7.0
#	  libcoap
# https://codeload.github.com/dthaler/libcoap/zip/develop
#	  mbedtls
# https://codeload.github.com/armmbed/mbedtls/zip/develop
#	  sqlite3
# https://www.sqlite.org/2017/sqlite-amalgamation-3200000.zip
#	  tinycbor
# https://codeload.github.com/01org/tinycbor/zip/develop
#	  Python
# https://www.python.org/ftp/python/2.7.13/python-2.7.13.msi
#	  pywin32-220.win32-py2.7
# https://sourceforge.net/projects/pywin32/files/pywin32/Build%20221/pywin32-221.win32-py2.7.exe/download
# https://newcontinuum.dl.sourceforge.net/project/pywin32/pywin32/Build%20221/pywin32-221.win32-py2.7.exe
#	  nuget
# https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
#	  git
# https://github.com/git-for-windows/git/releases/download/v2.14.1.windows.1/Git-2.14.1-64-bit.exe
#	  CMake
# https://cmake.org/files/v3.9/cmake-3.9.1-win64-x64.zip
# https://cmake.org/files/v3.9/cmake-3.9.1-win32-x86.zip
#