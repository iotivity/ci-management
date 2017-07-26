Add-Type -AssemblyName System.IO.Compression.FileSystem

ping google.com

$zipfile="curl_754_0_ssl.zip"
mkdir -Force "C:\util"
echo wget http://www.paehl.com/open_source/?download=$zipfile -OutFile "$PWD\$zipfile"
wget http://www.paehl.com/open_source/?download=$zipfile -OutFile "$PWD\$zipfile"

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes("$PWD\$zipfile")))

if ( $hash -eq "c5eb85c513bdeea9c129aa05f7785b22" ){
  [System.IO.Compression.ZipFile]::ExtractToDirectory("$PWD\$zipfile", "C:\util")
}else{
  echo "hash mismatch"
  exit 1
}


rm "$PWD\$zipfile"
