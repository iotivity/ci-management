echo "Installing Visual Studio 2013"

echo "Disk usage:"
Get-WmiObject win32_logicaldisk

#$vsSource="https://download.microsoft.com/download/7/1/B/71BA74D8-B9A0-4E6C-9159-A8335D54437E/vs_community.exe"
#$vsDest="c:\packer\vs_community.exe"
#& c:\ProgramData\chocolatey\bin\curl.exe -k -o $vsDest $vsSource
#& $vsDest /Quiet /NoRestart /AdminFile c:\packer\AdminDeployment-ws2012-vs2015.xml
# sleep for 25 minutes
#Start-Sleep -s 1500
choco install -y visualstudiocommunity2013

if (!(Test-Path $profile)) {
  mkdir -force ([system.io.fileinfo]$profile).DirectoryName

  echo '$env:PATH+=";C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin"' > $profile
}

