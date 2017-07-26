echo "Installing Visual Studio 2015"

$vs_iso="en_visual_studio_professional_2015_with_update_3_x86_x64_dvd_8923272.iso"

$vs_installer="vs_professional.exe"
$vs_hash="95-9E-20-67-2E-1A-8B-BC-8E-46-BA-FD-22-66-B4-FD"
echo "vs_installer=$vs_installer"

$vs_adminfile="C:\Packer\AdminDeployment-ws2012-vs2015.xml"
echo "vs_adminfile=$vs_adminfile"

$abs_vs_iso="$HOME\Downloads\$vs_iso"

if([System.IO.File]::Exists($abs_vs_iso)){
  Mount-DiskImage $abs_vs_iso
}else{
  echo "Visual Studio ISO was not downloaded"
  exit 1
}

$installer_drive="D:"
$abs_vs_installer="$installer_drive\$vs_installer"

Get-Date -f u
if(![System.IO.File]::Exists($abs_vs_installer)){
  echo "Visual Studio ISO was not mounted correctly"
  exit 1
}

echo "$abs_vs_installer /adminfile $vs_adminfile /quiet /norestart"
& $abs_vs_installer /adminfile $vs_adminfile /quiet /norestart

$slept = 0
do {
  sleep 5
  $slept += 5
  Write-Host -NoNewline "."
} while ( [bool](Get-Process vs_professional*) )

Write-Host "Done"
Get-Date -f u

Write-Host "Install took $slept seconds!"

if ( $slept -lt 50 ){
  echo "Installation period was too short.  Failing."
  Select-String -Path $HOME\AppData\Local\Temp\dd_vs_professional_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].log -Pattern error
  exit 3
}

# TODO: check $PATH for expected utilities

echo "Visual Studio 2015 Installed"