# Print disk size
echo "Disk usage:"
Get-WmiObject win32_logicaldisk

# # Resize first partition of first disk to maximum size
# Get-Partition -DiskNumber 0 -PartitionNumber 1
# $size = (Get-PartitionSupportedSize -DiskNumber 0 -PartitionNumber 1)
# Resize-Partition -DiskNumber 0 -PartitionNumber 1 -Size $size.SizeMax
#
# # Print disk size
# echo "Disk usage:"
# Get-WmiObject win32_logicaldisk

Write-Host "Installing Visual Studio 2015"

# # https://chocolatey.org/packages/VisualStudio2015Community
# choco install -y visualstudio2015community

Write-Host "Free disk Space:"
Get-WMIObject Win32_LogicalDisk | ForEach-Object {$_.freespace / 1GB}

$vsSource="https://download.microsoft.com/download/0/B/C/0BC321A4-013F-479C-84E6-4A2F90B11269/vs_community.exe"
$vsDest="c:\packer\vs_community.exe"
& c:\ProgramData\chocolatey\bin\curl.exe -k -o $vsDest $vsSource
& $vsDest /Quiet /NoRestart /AdminFile c:\packer\AdminDeployment-ws2012-vs2015.xml

if (!(Test-Path $profile)) {
  mkdir -force ([system.io.fileinfo]$profile).DirectoryName

  echo '$env:PATH+=";C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin"' > $profile
}

Function Test-VS-Install{
  if (Test-Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\cl.exe") {
    echo "Visual Studio 2015 Installed"
    return $True
  }else{
    echo "installation of Visual Studio 2015 may not have been successful"
    return $False
  }
}

# For($i=0; $i -lt 3; $i++){
#   if( Test-VS-Install == False ){
#     # sleep for 50 minutes
#     Start-Sleep -s 3000
#   }
# }


