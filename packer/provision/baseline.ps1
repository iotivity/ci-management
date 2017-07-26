#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

Add-Type -AssemblyName System.IO.Compression.FileSystem

#$cbi_msi="CloudbaseInitSetup.msi"
#$cbi_msi="CloudbaseInitSetup_Stable_x64.msi"
#$cbi_msi="CloudbaseInitSetup_Stable_x86.msi"
#c:\ProgramData\chocolatey\bin\curl.exe -o "c:\packer\$cbi_msi" "http://moonunit.colliertech.org/~cjac/tmp/$cbi_msi"

$tmp_dir="$HOME\AppData\Local\Temp\"
$deps_dir="C:\j\e"

if (!(Test-Path $deps_dir)) {
  mkdir -Force $deps_dir
  echo "destination directory [$deps_dir] created"
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

  $repo_dir=Join-Path $checkout_dir $repo_name
  echo "git clone $github_url $repo_dir"
  & git clone $github_url $repo_dir
  cd $repo_dir
  & git checkout $tag
}

echo "removing password expiry"
& C:\packer\unlimited-password-expiration.bat
echo "enabling RDP"
& C:\packer\enable-rdp.bat
echo "disabling UAC"
& C:\packer\uac-disable.bat
echo "disabling hibernate"
& C:\packer\disable-hibernate.bat

fetch-git-repo "libcoap" "dthaler/libcoap" "IoTivity-1.2.1d"
fetch-git-repo "mbedtls" "armmbed/mbedtls" "mbedtls-2.4.2"
fetch-git-repo "tinycbor" "01org/tinycbor" "v0.4.1"

# include-raw-iotivity-windows-bootstrap.bat expects tinycbor to be in this directory
xcopy /q /e /i /y "$deps_dir\tinycbor\tinycbor" "$deps_dir\tinycbor\tinycbor-0.4"

#
# ZIP FILES
#
# boost_1_60_0.zip
# https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.zip
#
# gtest-1.7.0.zip
# https://codeload.github.com/google/googletest/zip/release-1.7.0
#
# sqlite-amalgamation-3081101.zip
# https://downloads.sourceforge.net/project/cyqlite/3.8.11/sqlite-amalgamation-3081101.zip?ts=1504225376&use_mirror=gigenet

$boost_file='boost_1_60_0.zip'

$filenames = @($boost_file,
	       'gtest-1.7.0.zip',
	       'googletest-release-1.7.0.zip',
	       'sqlite-amalgamation-3081101.zip',
	       'slave.jar'
	       )
foreach ($file in $filenames) {
  # This should probably be hosted elsewhere
  c:\ProgramData\chocolatey\bin\curl.exe -o "$deps_dir\$file" "http://moonunit.colliertech.org/~cjac/tmp/$file"
}

echo "unpacking boost"
[System.IO.Compression.ZipFile]::ExtractToDirectory("$deps_dir\$boost_file", "$deps_dir\temp")
Remove-Item "$deps_dir\$boost_file"
Remove-Item "$deps_dir\boost" -recurse
move "$deps_dir\temp\boost_*" "$deps_dir\boost"

echo "disabling windows update"
& C:\packer\disablewinupdate.bat

echo "installing ssh server"
& choco install -y openssh -params '"/SSHServerFeature"'

