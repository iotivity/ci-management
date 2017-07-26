#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

Add-Type -AssemblyName System.IO.Compression.FileSystem

$util_dir="C:\Util\"
$dst_dir=$util_dir
if (!(Test-Path $dst_dir)) {
  mkdir -Force $dst_dir
  echo "destination directory [$dst_dir] created"
}

$download_dir="$HOME\Downloads\"
$md5 = New-Object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider

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

  return( $is_match )
}

$curl_path=$util_dir+"curl.exe"
function curl
{
  $src=$arg[0]
  $dst=$arg[1]

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

$deps_dir="C:\j\e\"
function fetch-git-repo
{
  $repo_name=$args[0]
  $github_path=$args[1]
  $tag=$args[2]

  $github_url="https://github.com/$github_path.git"
  $checkout_dir="$deps_dir$repo_name\$repo_name"

  & git clone $github_url $checkout_dir
  cd $checkout_dir
  & git checkout $tag
}

function fetch-zipexe
{
  $version=$args[0]
  $zipfile=$args[1]
  $bin=$args[2]
  $src_fmt=$args[3]
  $expected_hash=$args[4]

  if( $src_fmt -Match "{1}" ){
    $src = $src_fmt -f $version, $zipfile
  }elseif($src_fmt -Match "{0}" -and
          $zipfile -Match "{0}" ){
    $zipfile = $zipfile -f $version
    $src = $src_fmt -f $zipfile
  }else{
    echo "source unrecognized: $src_fmt"
    exit 1
  }

  $abs_zipfile=$download_dir+$zipfile
  echo "abs_zipfile=$abs_zipfile"

  curl( $src, $abs_zipfile )

  if ( -Not check-hash( $abs_zipfile, $expected_hash ) ){
    Remove-Item $abs_zipfile
    exit 2
  }

  $tmp_dir="$HOME\AppData\Local\Temp\$zipfile"

  if (!(Test-Path $tmp_dir)) {
    mkdir -Force $tmp_dir
    echo "temp directory [$tmp_dir] created"
  }

  [System.IO.Compression.ZipFile]::ExtractToDirectory($abs_zipfile, $tmp_dir)

  if(![System.IO.File]::Exists($tmp_dir+$bin)){
    echo "[$bin] does not exist within zipfile [$zipfile]"
    Remove-Item $abs_zipfile
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

  $tmp_dir="$HOME\AppData\Local\Temp\"

  curl( $src, $tmp_dir+$bin )

  if ( -Not check-hash( $tmp_dir+$bin, $expected_hash ) ){
    Remove-Item $tmp_dir+$bin
    exit 2
  }

  Copy-Item $tmp_dir+$bin $dst_dir+$bin

}



echo "fetching cURL"
& C:\packer\fetch-curl.ps1

#echo "fetching PSWindowsUpdate"
#& C:\packer\install-PSWindowsUpdate.ps1
#echo "updating windows"
#$cred = get-credential
#Invoke-Command -ComputerName localhost -credential $cred -scriptblock {& C:\packer\win-updates.ps1}
#& C:\packer\windows-update.ps1

echo "removing password expiry"
& C:\packer\unlimited-password-expiration.bat
echo "enabling RDP"
& C:\packer\enable-rdp.bat
echo "disabling UAC"
& C:\packer\uac-disable.bat
echo "disabling hibernate"
& C:\packer\disable-hibernate.bat


# Other dependencies

#
# Curl
#
fetch-zipexe( "754_1_ssl",
              "curl_{0}.zip",
              "curl.exe",
              "http://www.paehl.com/open_source/?download={0}" )

#
# Nuget
#
fetch-exe( "latest",
	   "nuget.exe",
	   "https://dist.nuget.org/win-x86-commandline/{0}/{1}}" )

#
# ZIP FILES
#
# boost_1_60_0.zip
# https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.zip
#
# gtest-1.7.0.zip
# https://codeload.github.com/google/googletest/zip/release-1.7.0
#
# sqlite3
# https://www.sqlite.org/2017/sqlite-amalgamation-3200000.zip
#
# CMake
# https://cmake.org/files/v3.9/cmake-3.9.1-win64-x64.zip
# https://cmake.org/files/v3.9/cmake-3.9.1-win32-x86.zip

fetch-git-repo( "libcoap", "dthaler/libcoap", "IoTivity-1.2.1c")
fetch-git-repo( "mbedtls", "armmbed/mbedtls", "mbedtls-2.4.2")
fetch-git-repo( "tinycbor", "01org/tinycbor", "v0.4.1")

echo "connect to system console and perform windows update now."
echo "When finished, create a file $HOME\AppData\Local\Temp\update-done.txt"

$slept = 0
Get-Date -f u
do {
  sleep 5
  $slept += 5
  Write-Host -NoNewline "."
} while(![System.IO.File]::Exists("$HOME\AppData\Local\Temp\update-done.txt"))
rm $HOME\AppData\Local\Temp\update-done.txt
echo "Done"
Get-Date -f u

echo "fetching vs2015"
& C:\packer\fetch-vs2015.ps1

echo "Installing vs2015"
& C:\packer\install-vs2015.ps1

#
# INSTALLERS
#
# Python
#
# version=2.7.13
# https://www.python.org/ftp/python/$version/python-$version.msi

$file=python-2.7.13.msi

curl( "http://moonunit.colliertech.org/~cjac/tmp/$file",
      $download_dir+$file )
#
# pywin32
#
# https://newcontinuum.dl.sourceforge.net/project/pywin32/pywin32/Build%20221/pywin32-221.win32-py2.7.exe

$file=pywin32-221.win32-py2.7.exe

curl( "http://moonunit.colliertech.org/~cjac/tmp/$file",
      $download_dir+$file )

#
# git
#
# https://github.com/git-for-windows/git/releases/download/v2.14.1.windows.1/Git-2.14.1-64-bit.exe

$file=Git-2.14.1-64-bit.exe

curl( "http://moonunit.colliertech.org/~cjac/tmp/$file",
      $download_dir+$file )

echo "connect to system console and install from packages in $download_dir now."
echo "When finished, create a file $HOME\AppData\Local\Temp\update-done.txt"

$slept = 0
Get-Date -f u
do {
  sleep 5
  $slept += 5
  Write-Host -NoNewline "."
} while(![System.IO.File]::Exists("$HOME\AppData\Local\Temp\update-done.txt"))
rm $HOME\AppData\Local\Temp\update-done.txt
echo "Done"
Get-Date -f u

echo "disabling windows update"
& C:\packer\disablewinupdate.bat
