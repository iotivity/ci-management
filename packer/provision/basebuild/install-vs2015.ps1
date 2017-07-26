$vs_iso="en_visual_studio_professional_2015_with_update_3_x86_x64_dvd_8923272.iso"
$vs_iso_url="http://moonunit.colliertech.org/images/$vs_iso"

$vs_installer="en_visual_studio_professional_2015_with_update_3_x86_x64_web_installer_8922978.exe"
$vs_hash="95-9E-20-67-2E-1A-8B-BC-8E-46-BA-FD-22-66-B4-FD"
echo "vs_installer=$vs_installer"

$vs_adminfile="C:\Packer\AdminDeployment-ws2012-vs2015.xml"
echo "vs_adminfile=$vs_adminfile"

$vs_url="https://my.visualstudio.com/Downloads?pid=2088"
echo "vs_url=$vs_url"
$vs_url="http://moonunit.colliertech.org/~cjac/tmp/$vs_installer"

$curl_bin="C:\util\curl.exe"

$abs_vs_installer="$HOME\Downloads\$vs_installer"

if(![System.IO.File]::Exists($abs_vs_installer)){
  echo "c:\util\curl.exe -o $abs_vs_installer $vs_url"

  & $curl_bin -o $abs_vs_installer $vs_url

  if(![System.IO.File]::Exists($abs_vs_installer)){
    echo "Visual Studio Installer was not downloaded"
    exit 1
  }
}

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($abs_vs_installer)))

if ( $hash -eq $vs_hash ){
  echo "hash match.  successful download"
}else{
  echo "hash mismatch"
  echo "$vs_hash expected"
  echo "$hash received"
  exit 2
}

Get-Date -f u

echo "$abs_vs_installer /adminfile $vs_adminfile /quiet /norestart"
& $abs_vs_installer /adminfile $vs_adminfile /quiet /norestart

$slept = 0
do {
  sleep 5
  $slept += 5
  Write-Host -NoNewline "."
} while ( [bool](Get-Process en_visual_studio*) )

Write-Host "Done"
Get-Date -f u

Write-Host "Install took $slept seconds!"

if ( $slept -lt 100 ){
  echo "Installation period was too short.  Failing."
  Select-String -Path $HOME\AppData\Local\Temp\dd_vs_professional_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].log -Pattern error
  exit 3
}


# TODO: check $PATH for expected utilities


