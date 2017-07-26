#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

Add-Type -AssemblyName System.IO.Compression.FileSystem

$deps_dir="C:\j\e"

$boost_dir="C:\j\e\boost\"

if (!(Test-Path $deps_dir)) {
  mkdir -Force $deps_dir
  echo "destination directory [$deps_dir] created"
}

echo "installing ssh server"
& choco install -y openssh -params '"/SSHServerFeature"'

echo "installing git and curl"
& choco install -y git curl

if (!(Test-Path $boost_dir)) {
  mkdir -Force $boost_dir
  echo "destination directory [$boost_dir] created"
}

function fetch-github-repo
{
  $repo_name=$args[0]
  $owner_name=$args[1]
  $github_path="$owner_name/$repo_name"
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

fetch-github-repo "libcoap" "dthaler" "IoTivity-1.2.1d"
fetch-github-repo "mbedtls" "armmbed" "mbedtls-2.4.2"
fetch-github-repo "tinycbor" "01org" "v0.4.1"

mkdir c:\j\src
function fetch-gerrit-repo
{
  $project_name=$args[0]
  & git clone "https://gerrit.iotivity.org/gerrit/p/$project_name.git" "c:\j\src\$project_name"
}

$project_names = @('iotivity',
'iotivity-alljoyn-bridge',
'iotivity-constrained',
'iotivity-contrib',
'iotivity-node',
'iotivity-test',
'iotivity-upnp-bridge',
'iotivity-voice',
'iotivity-xmpp'
	       )
foreach ($project in $project_names) {
  fetch-gerrit-repo $project
}

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
