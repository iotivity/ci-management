#!/bin/bash -eux
set -o pipefail

IOTIVITYEXTLIB="/extlibs"

# Toolchain package
toolchain_name="gcc"
toolchain_abi="arm-none-eabi"
toolchain_version="6-2017-q1-update"
toolchain_host="linux"
toolchain_package="${toolchain_name}-${toolchain_abi}-${toolchain_version}"
toolchain_url="https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/6_1-2017q1/${toolchain_file}"
toolchain_dir="${IOTIVITYEXTLIB}/${toolchain_package}"

rm -rf "${WORKSPACE}/${toolchain_dir}"

# gcc (for TizenRT)
if [ ! -d "${IOTIVITYEXTLIB}${toolchain_dir}" ]; then
    mkdir -p "${IOTIVITYEXTLIB}"
    cd "${IOTIVITYEXTLIB}"
    curl -sL "${toolchain_url}" | tar xj
    ln -fs "${IOTIVITYEXTLIB}${toolchain_dir}" "${WORKSPACE}/${toolchain_dir}"
fi
