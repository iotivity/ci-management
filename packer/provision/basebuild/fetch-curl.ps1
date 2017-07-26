Add-Type -AssemblyName System.IO.Compression.FileSystem

ping google.com

$curl_version="754_1_ssl"
echo "curl_version=$curl_version"

$curl_hash="c5eb85c513bdeea9c129aa05f7785b22"
echo "curl_hash=$curl_hash"

$zipfile="curl_"+$curl_version+".zip"
echo "zipfile=$zipfile"

#$curl_url="http://www.paehl.com/open_source/?download="+$zipfile
$curl_url="http://moonunit.colliertech.org/~cjac/tmp/curl_754_1_ssl.zip"
echo "curl_url=$curl_url"

$dst_dir="C:\util"
$abszipfile="$PWD\$zipfile"

if (!(Test-Path $dst_dir)) {
  mkdir -Force $dst_dir
}

if(![System.IO.File]::Exists($abszipfile)){
  echo "wget $curl_url -OutFile $abszipfile"
  wget $curl_url -OutFile $abszipfile
#  c:\util\curl.exe -o $abszipfile $curl_url

  if(![System.IO.File]::Exists($abszipfile)){
    echo "zipfile was not downloaded"
    exit 1
  }
}

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($abszipfile)))

if ( $hash -eq $curl_hash ){
  [System.IO.Compression.ZipFile]::ExtractToDirectory($abszipfile, $dst_dir)
}else{
  echo "hash mismatch"
  exit 2
}


rm $abszipfile
