echo "Installing Visual Studio 2015"

echo "Disk usage:"
Get-WmiObject win32_logicaldisk

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

