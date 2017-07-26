# Print disk size
echo "Disk usage:"
Get-WmiObject win32_logicaldisk

# Resize first partition of first disk to maximum size
Get-Partition -DiskNumber 0 -PartitionNumber 1
$size = (Get-PartitionSupportedSize -DiskNumber 0 -PartitionNumber 1)
Resize-Partition -DiskNumber 0 -PartitionNumber 1 -Size $size.SizeMax

# Print disk size
echo "Disk usage:"
Get-WmiObject win32_logicaldisk

echo "Installing Visual Studio 2017"

choco install -y windows-sdk-10.1

#if( $? -ne 0 ){
#&  type C:\Users\Admin\AppData\Local\Temp\chocolatey\windows-sdk-10.1*.log
#}

choco install -y jdk8

$win_sdk_ver="15063"

echo "Adding Visual Studio and tools to PATH"
if (!(Test-Path $profile)) {
  mkdir -force ([system.io.fileinfo]$profile).DirectoryName

  echo '$env:PATH+=";C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin"' > $profile
}

echo "Disk usage:"
# Get-WmiObject win32_logicaldisk
Get-WmiObject Win32_LogicalDisk -filter "DeviceID = 'c:' "

$c_disk=Get-Volume 'c'

# chocolatey install -y VisualStudio2017buildtools VisualStudio2017Community
chocolatey install -y VisualStudio2017buildtools

#$vsSource="https://aka.ms/vs/15/release/vs_community.exe"
$vsSource="https://download.visualstudio.microsoft.com/download/pr/100359697/045b56eb413191d03850ecc425172a7d/vs_Community.exe"
$vsDest="c:\packer\vs_community.exe"
& c:\ProgramData\chocolatey\bin\curl.exe -k -o $vsDest $vsSource
& $vsDest `
    --add Microsoft.VisualStudio.Workload.Universal `
    --add Microsoft.VisualStudio.Component.VC.140 `
    --add Microsoft.VisualStudio.Component.VC.CoreIde `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.VisualStudio.Component.Windows81SDK `
    --add Microsoft.VisualStudio.Component.Windows10SDK `
    --add Microsoft.VisualStudio.Component.Windows10SDK.$win_sdk_ver.Desktop `
    --add Microsoft.VisualStudio.Component.Windows10SDK.$win_sdk_ver.UWP `
    --add Microsoft.VisualStudio.ComponentGroup.UWP.VC `
    --add Microsoft.VisualStudio.Component.UWP.Support `
    --add Microsoft.Component.VC.Runtime.OSSupport `
    --add Microsoft.Component.NetFX.Native `
    --add Microsoft.Component.MSBuild `
    --add Microsoft.Net.Component.4.5.TargetingPack `
    --add Microsoft.Net.Component.4.7.SDK `
    --add Microsoft.Net.Component.4.7.TargetingPack `
    --add Component.Android.SDK23 `
    --quiet --wait --norestart

echo "visual studio installer executed.  Waiting for 60m for completion..."

# sleep for 60 minutes
Start-Sleep -s 3600

Function Test-VS-Install{
  if (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\cl.exe") {
    echo "Visual Studio 2017 Installed"
    return $True
  }else{
    echo "installation of Visual Studio 2017 may not have been successful"
    return $False
  }
}

For($i=0; $i -lt 3; $i++){
  if( Test-VS-Install == $False ){
    # sleep for 50 minutes
    Start-Sleep -s 3000
  }
}

# TODO: check include path for expected headers

