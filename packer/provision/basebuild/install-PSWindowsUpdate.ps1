Add-Type -AssemblyName System.IO.Compression.FileSystem

$PSWindowsUpdate_zipfile="PSWindowsUpdate.zip"
$PSWindowsUpdate_url="http://moonunit.colliertech.org/~cjac/tmp/$PSWindowsUpdate_zipfile"


$dst_dir1="$HOME\Documents\WindowsPowerShell\Modules"

if (!(Test-Path $dst_dir1)) {
  mkdir -Force $dst_dir1
}

$dst_dir2="C:\windows\System32\WindowsPowerShell\v1.0\Modules"

if (!(Test-Path $dst_dir2)) {
  mkdir -Force $dst_dir2
}

$expected_hash="56-69-67-50-6F-7C-B7-A9-56-9E-57-48-77-4B-DA-3A"

$curl_bin="C:\util\curl.exe"

#$abs_vs_installer="$HOME\Downloads\$vs_installer"
$abs_PSWindowsUpdate_zipfile="$HOME\Downloads\$PSWindowsUpdate_zipfile"

if(![System.IO.File]::Exists($abs_vs_installer)){
  echo "c:\util\curl.exe -o $abs_PSWindowsUpdate_zipfile $PSWindowsUpdate_url"

  & c:\util\curl.exe -o $abs_PSWindowsUpdate_zipfile $PSWindowsUpdate_url

  if(![System.IO.File]::Exists($abs_PSWindowsUpdate_zipfile)){
    echo "PSWindowsUpdate was not downloaded"
    exit 1
  }
}

$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
$hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($abs_PSWindowsUpdate_zipfile)))

if ( $hash -eq $expected_hash ){
  [System.IO.Compression.ZipFile]::ExtractToDirectory($abs_PSWindowsUpdate_zipfile, $dst_dir1)
  [System.IO.Compression.ZipFile]::ExtractToDirectory($abs_PSWindowsUpdate_zipfile, $dst_dir2)
  echo "curl unpacked to $dst_dir1 and $dst_dir2"
  rm $abs_PSWindowsUpdate_zipfile
}else{
  echo "hash mismatch."
  echo "$expected_hash expected"
  echo "$hash received"
  exit 2
}
