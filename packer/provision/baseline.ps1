#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

Add-Type -AssemblyName System.IO.Compression.FileSystem
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider

$download_dir="$HOME\Downloads\"
$tmp_dir="$HOME\AppData\Local\Temp\"
$util_dir="C:\Util\"
$deps_dir="C:\j\e\"
$dst_dir=$util_dir
$curl_path=$util_dir+"curl.exe"

if (!(Test-Path $dst_dir)) {
  mkdir -Force $dst_dir
  echo "destination directory [$dst_dir] created"
}

function check-hash
{
  $filename=$args[0]
  $expected_hash=$args[1]
  $hash = [System.BitConverter]::ToString($md5.ComputeHash([System.IO.File]::ReadAllBytes($filename)))

  $is_match = $hash -eq $expected_hash

  if( !$is_match ){
    echo "$expected_hash expected"
    echo "$hash received"
  }

  echo "$expected_hash expected"
  echo "$hash received"

  return $is_match
}

function docurl
{
  $src=$args[0]
  $dst=$args[1]

  if(![System.IO.File]::Exists($dst)){
    if([System.IO.File]::Exists($curl_path)){
      & $curl_path -o $dst $src
    }else{
      wget $src -OutFile $dst
    }
  }

  if(![System.IO.File]::Exists($dst)){
    echo "file $src was not downloaded to $dst"
    exit 1
  }
}

function fetch-git-repo
{
  $repo_name=$args[0]
  $github_path=$args[1]
  $tag=$args[2]

  $github_url="https://github.com/$github_path.git"

  $checkout_dir = Join-Path $deps_dir $repo_name

  if (!(Test-Path $checkout_dir)) {
    mkdir -Force $checkout_dir
    echo "destination directory [$checkout_dir] created"
  }

  echo "git clone $github_url $checkout_dir\$repo_name"
  & git clone $github_url $checkout_dir
  cd $checkout_dir
  & git checkout $tag
}

function fetch-zip
{
  $src=$args[0]
  $zipfile=$args[1]
  $expected_hash=$args[2]

  $abs_zipfile=$download_dir+$zipfile

  echo "src=$src"
  echo "zipfile=$zipfile"
  echo "abs_zipfile=$abs_zipfile"
  echo "expected_hash=$expected_hash"

  docurl $src $abs_zipfile

  $hash = get-filehash $abs_zipfile

  if ( $hash -eq $expected_hash ){
    echo "hash match"
  }else{
    Remove-Item $abs_zipfile
    exit 2
  }

  echo "zipfile downloaded to $abs_zipfile"
}

function fetch-zipexe
{
  $version=$args[0]
  $zipfile=$args[1]
  $bin=$args[2]
  $src_fmt=$args[3]
  $expected_hash=$args[4]

  echo "version=$version"
  echo "zipfile=$zipfile"
  echo "bin=$bin"
  echo "src_fmt=$src_fmt"
  echo "expected_hash=$expected_hash"

  if( $src_fmt -Match '\{1}' ){
    $src = $src_fmt -f $version, $zipfile
  }elseif($src_fmt -Match '\{0}' -and
          $zipfile -Match '\{0}' ){
    $zipfile = $zipfile -f $version
    $src = $src_fmt -f $zipfile
  }else{
    echo "source unrecognized: [$src_fmt]"
    exit 1
  }

  fetch-zip $src $zipfile $expected_hash

  $abs_zipfile=$download_dir+$zipfile
  echo "abs_zipfile=$abs_zipfile"
  $tmp_dir="$HOME\AppData\Local\Temp\$zipfile"

  if([System.IO.File]::Exists($abs_zipfile)){
    echo "extracting [$abs_zipfile] to [$tmp_dir]"
    echo "[System.IO.Compression.ZipFile]::ExtractToDirectory($abs_zipfile, $tmp_dir)"
    [System.IO.Compression.ZipFile]::ExtractToDirectory($abs_zipfile, $tmp_dir)
  }else{
    echo "zipfile [$abs_zipfile] does not exist"
  }

  if(![System.IO.File]::Exists($tmp_dir+$bin)){
    echo "[$bin] does not exist within zipfile [$zipfile]"
#    Remove-Item $abs_zipfile
    exit 3
  }

  Copy-Item $tmp_dir+$bin $dst_dir+$bin
  if(![System.IO.File]::Exists($dst_dir+$bin)){
    echo "could not copy [$bin] to [$dst_dir]"
  }
}

function fetch-exe
{
  $version=$args[0]
  $bin=$args[1]
  $src_fmt=$args[2]

  $dst=$dst_dir + $bin
  $src=$src_fmt -f $version, $pkg

  $dst=$util_dir+$bin

  docurl $src $tmp_dir+$bin

  $is_match = check-hash $tmp_dir+$bin $expected_hash

  if ( $is_match ){
    echo "hash match"
  }else{
    Remove-Item $tmp_dir+$bin
    exit 2
  }

  Copy-Item $tmp_dir+$bin $dst_dir+$bin
}

echo "removing password expiry"
& C:\packer\unlimited-password-expiration.bat
echo "enabling RDP"
& C:\packer\enable-rdp.bat
echo "disabling UAC"
& C:\packer\uac-disable.bat
echo "disabling hibernate"
& C:\packer\disable-hibernate.bat

#
# ZIP FILES
#
# boost_1_60_0.zip
# https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.zip
$file=boost_1_60_0.zip
curl -o "c:\j\e\$file" "http://moonunit.colliertech.org/~cjac/tmp/$file"
#
# gtest-1.7.0.zip
# https://codeload.github.com/google/googletest/zip/release-1.7.0
$file=gtest-1.7.0.zip
curl -o "c:\j\e\$file" "http://moonunit.colliertech.org/~cjac/tmp/$file"
$file=googletest-release-1.7.0.zip
curl -o "c:\j\e\$file" "http://moonunit.colliertech.org/~cjac/tmp/$file"
#
# sqlite-amalgamation-3081101.zip
# https://downloads.sourceforge.net/project/cyqlite/3.8.11/sqlite-amalgamation-3081101.zip?ts=1504225376&use_mirror=gigenet
$file=sqlite-amalgamation-3081101.zip
curl -o "c:\j\e\$file" "http://moonunit.colliertech.org/~cjac/tmp/$file"


fetch-git-repo "libcoap" "dthaler/libcoap" "IoTivity-1.2.1d"
fetch-git-repo "mbedtls" "armmbed/mbedtls" "mbedtls-2.4.2"
fetch-git-repo "tinycbor" "01org/tinycbor" "v0.4.1"

# pywin32
#
# https://newcontinuum.dl.sourceforge.net/project/pywin32/pywin32/Build%20221/pywin32-221.win32-py2.7.exe

#$file=pywin32-221.win32-py2.7.exe

echo "disabling windows update"
& C:\packer\disablewinupdate.bat
