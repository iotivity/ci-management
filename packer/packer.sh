#!/bin/bash -eu
set -o pipefail

PACKER_URL=https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_amd64.zip

if [ ! -f bin/packer ]; then
  curl -sSL $PACKER_URL -o bin/packer.zip
  unzip -d bin bin/packer.zip
  rm bin/packer.zip
  sha256sum -c packer_sha256.txt
fi

if [ -f 'account.json' ]; then
    export GCE_ACCOUNT_JSON="$(cat account.json)"
fi

for PACKER_CONFIG in $(ls *.json | grep -v account.json); do
    echo "> Validating: $PACKER_CONFIG"
    bin/packer validate $PACKER_CONFIG
done

bin/packer build --only docker baseline.json

unset GCE_ACCOUNT_JSON
