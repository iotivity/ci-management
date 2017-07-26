#!/usr/bin/env powershell
# vi: ts=4 sw=4 sts=4 et :

$deps_dir="C:\j\e"

if (!(Test-Path $deps_dir)) {
  mkdir -Force $deps_dir
  echo "destination directory [$deps_dir] created"
}

echo "installing ssh server"
& choco install -y openssh -params '"/SSHServerFeature"'
