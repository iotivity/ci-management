echo "Downloading visual studio 2015"

$vs_iso="en_visual_studio_professional_2015_with_update_3_x86_x64_dvd_8923272.iso"
$vs_iso_url="http://moonunit.colliertech.org/images/$vs_iso"

#$vs_installer="en_visual_studio_professional_2015_with_update_3_x86_x64_web_installer_8922978.exe"
$vs_installer="vs_professional.exe"
$vs_hash="95-9E-20-67-2E-1A-8B-BC-8E-46-BA-FD-22-66-B4-FD"
echo "vs_installer=$vs_installer"

$vs_adminfile="C:\Packer\AdminDeployment-ws2012-vs2015.xml"
echo "vs_adminfile=$vs_adminfile"

$vs_url="https://my.visualstudio.com/Downloads?pid=2088"
echo "vs_url=$vs_url"
$vs_url="http://moonunit.colliertech.org/~cjac/tmp/$vs_installer"

$curl_bin="C:\util\curl.exe"

#$abs_vs_installer="$HOME\Downloads\$vs_installer"
$installer_drive="D:"
$abs_vs_installer="$installer_drive\$vs_installer"
$abs_vs_iso="$HOME\Downloads\$vs_iso"

if(![System.IO.File]::Exists($abs_vs_installer)){
  echo "c:\util\curl.exe -o $abs_vs_iso $vs_iso_url"

  & $curl_bin -o $abs_vs_iso $vs_iso_url

  if(![System.IO.File]::Exists($abs_vs_iso)){
    echo "Visual Studio ISO was not downloaded"
    exit 1
  }
}

Mount-DiskImage $abs_vs_iso

#$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
#$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($abs_vs_installer)))

#if ( $hash -eq $vs_hash ){
#  echo "hash match.  successful download"
#}else{
#  echo "hash mismatch"
#  echo "$vs_hash expected"
#  echo "$hash received"
#  exit 2
#}

echo "Visual Studio 2015 downloaded"