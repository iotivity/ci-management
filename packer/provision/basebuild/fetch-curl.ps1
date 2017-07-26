Add-Type -AssemblyName System.IO.Compression.FileSystem

$curl_version="754_1_ssl"
echo "curl_version=$curl_version"

$curl_hash="C5-EB-85-C5-13-BD-EE-A9-C1-29-AA-05-F7-78-5B-22"
echo "curl_hash=$curl_hash"

$zipfile="curl_"+$curl_version+".zip"
echo "zipfile=$zipfile"

$curl_url="http://www.paehl.com/open_source/?download="+$zipfile
echo "curl_url=$curl_url"
$curl_url="http://moonunit.colliertech.org/~cjac/tmp/curl_754_1_ssl.zip"

$dst_dir="C:\util"
echo "dst_dir=$dst_dir"

$abs_zipfile="$HOME\Downloads\$zipfile"
echo "abs_zipfile=$abs_zipfile"

if (!(Test-Path $dst_dir)) {
  mkdir -Force $dst_dir
  echo ""
}

if(![System.IO.File]::Exists($abs_zipfile)){
  echo "wget $curl_url -OutFile $abs_zipfile"
  wget $curl_url -OutFile $abs_zipfile
#  c:\util\curl.exe -o $abs_zipfile $curl_url

  if(![System.IO.File]::Exists($abs_zipfile)){
    echo "zipfile was not downloaded"
    exit 1
  }
}

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($abs_zipfile)))

if ( $hash -eq $curl_hash ){
  [System.IO.Compression.ZipFile]::ExtractToDirectory($abs_zipfile, $dst_dir)
  echo "curl unpacked to $dst_dir"
  rm $abs_zipfile
}else{
  echo "hash mismatch."
  echo "$curl_hash expected"
  echo "$hash received"
  exit 2
}


