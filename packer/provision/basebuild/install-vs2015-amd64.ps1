echo "Installing Visual Studio 2015"

echo "Disk usage:"
Get-WmiObject win32_logicaldisk


#choco install -y VisualStudio2015Professional
#choco install -y visualstudio2015-update

#choco install --execution-timeout 0 -y KB3033929 chocolatey-windowsupdate.extension KB3035131 KB2999226 choco install vcredist2015
#choco install --execution-timeout 0 -y vcredist-all

#choco install --execution-timeout 0 -y vcbuildtools -ia "/Full"
#choco install --execution-timeout 0 -y mingw
#choco install --execution-timeout 0 -y vim
#choco install --execution-timeout 0 -y windows-sdk-7.1
#choco install --execution-timeout 0 -y windows-sdk-8.1
#choco install --execution-timeout 0 -y windows-sdk-10.1

$vsSource="https://download.microsoft.com/download/0/B/C/0BC321A4-013F-479C-84E6-4A2F90B11269/vs_community.exe"
$vsDest="c:\packer\vs_community.exe"
& c:\ProgramData\chocolatey\bin\curl.exe -k -o $vsDest $vsSource
& $vsDest /Quiet /NoRestart /AdminFile c:\packer\AdminDeployment-ws2012-vs2015.xml
# sleep for 25 minutes
Start-Sleep -s 1500

if (!(Test-Path $profile)) {
  mkdir -force ([system.io.fileinfo]$profile).DirectoryName

  echo '$env:PATH+=";C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin"' > $profile
}

#choco install --execution-timeout 0 -y VisualStudio2015Community --packageParameters "/AdminFile c:\packer\AdminDeployment-ws2012-vs2015.xml"

# TODO: check $PATH for expected utilities
# TODO: check include path for expected headers

