#!/bin/bash -eux
set -o pipefail

PATH=$PATH:/usr/local/bin/
ln -s /Users/jenkins-ci/extlibs/tinycbor/tinycbor $WORKSPACE/extlibs/tinycbor/tinycbor
