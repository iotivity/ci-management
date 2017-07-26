$vs_installer="en_visual_studio_professional_2015_with_update_3_x86_x64_web_installer_8922978.exe"
echo "vs_installer=$vs_installer"

$vs_adminfile="C:\Packer\AdminDeployment-ws2012-vs2015.xml"
echo "vs_adminfile=$vs_adminfile"

#$vs_url="https://my.visualstudio.com/Downloads?pid=2088"
$vs_url="http://moonunit.colliertech.org/~cjac/tmp/en_visual_studio_professional_2015_with_update_3_x86_x64_web_installer_8922978.exe"
echo "vs_url=$vs_url"

#$dst_dir="C:\util"
#$abszipfile="$PWD\$zipfile"

#if (!(Test-Path $dst_dir)) {
#  mkdir -Force $dst_dir
#}

if(![System.IO.File]::Exists($vs_installer)){
#  echo "wget $vs_url -OutFile $vs_installer"
#  wget $vs_url -OutFile $vs_installer
  c:\util\curl.exe -o $vs_installer $$vs_url

  if(![System.IO.File]::Exists($vs_installer)){
    echo "Visual Studio Installer was not downloaded"
    exit 1
  }
}

.\en_visual_studio_professional_2015_with_update_3_x86_x64_web_installer_8922978.exe /adminfile $vs_adminfile /norestart

#$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
#$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($abszipfile)))

#if ( $hash -eq $curl_hash ){
#  [System.IO.Compression.ZipFile]::ExtractToDirectory($abszipfile, $dst_dir)
#}else{
#  echo "hash mismatch"
#  exit 2
#}


#rm $abszipfile





#c:\util\curl.exe -o $vs_installer https://my.visualstudio.com/Downloads?pid=2088
#c:\util\curl.exe -o $vs_adminfile 

#$vs_installer /adminfile $vs_adminfile /norestart
#$vs_installer /Passive /LOG %SYSTEMROOT%\TEMP\VS_2015_U3.log /NoWeb /NoRefresh /Full



