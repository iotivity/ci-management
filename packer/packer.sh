#!/bin/bash -eu
set -o pipefail

PACKER_URL=https://releases.hashicorp.com/packer/0.11.0/packer_0.11.0_linux_amd64.zip

if [ ! -f bin/packer.zip ]; then
  curl -sSL $PACKER_URL -o bin/packer.zip
  unzip -od bin bin/packer.zip
fi

sha256sum -c packer_sha256.txt

if [ -f 'account.json' ]; then
    export GCE_ACCOUNT_JSON="$(cat account.json)"
fi

for PACKER_CONFIG in $(ls *.json | grep -v account.json); do
    echo "> Validating: $PACKER_CONFIG"
    bin/packer validate $PACKER_CONFIG
done

#bin/packer build --only docker baseline.json

unset GCE_ACCOUNT_JSON
