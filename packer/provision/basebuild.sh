#!/bin/bash

# vim: ts=4 sw=4 sts=4 et tw=72 :

# force any errors to cause the script and job to end in failure
set -xeu -o pipefail

PACKERVER=1.0.0

rh_systems() {
    # Make sure the 'Development Tools' group is installed
    yum install -y @development

    # Install python dependencies
    yum install -y python-{devel,virtualenv,setuptools,pip}

    # Build dependencies for Python packages
    yum install -y openssl-devel mysql-devel gcc

    # Autorelease support packages
    yum install -y xmlstarlet

    # Packer builds happen from the centos flavor images
    PACKERDIR=$(mktemp -d)
    # disable double quote checking
    # shellcheck disable=SC2086
    cd $PACKERDIR || exit
    wget https://releases.hashicorp.com/packer/${PACKERVER}/packer_${PACKERVER}_linux_amd64.zip
    unzip packer_${PACKERVER}_linux_amd64.zip -d /usr/local/bin/
    # rename packer to avoid conflicts with cracklib
    mv /usr/local/bin/packer /usr/local/bin/packer.io

    # cleanup from the installation
    # disable double quote checking
    # shellcheck disable=SC2086
    rm -rf $PACKERDIR
    # cleanup from previous install process
    if [ -d /tmp/packer ]
    then
        rm -rf /tmp/packer
    fi
}

dpkg_wait() {
   WAITING=0
    while [ -n "$(ps auwx | grep '^root.*dpk[g]')" ]
    do
	if [ ${WAITING} == 0 ]
	then
	    echo "dpkg running"
	    WAITING=1
	fi
	sleep 10s
    done
}

ubuntu_systems() {
    find /etc/apt/ -name '*.list' | xargs perl -pi -e 's{ubuntu.mirror.vexxhost.com}{mirrors.kernel.org}g'
    apt-get clean
    apt-get update

    # Install python dependencies
    dpkg_wait
    apt-get install -y python-{dev,virtualenv,setuptools,pip}

    # Build dependencies for Python packages
    dpkg_wait
    apt-get install -y libssl-dev libmysqlclient-dev gcc


    # Install packages that are version specific
    FACTER_OSVER=$(/usr/bin/facter operatingsystemrelease)
    case "$FACTER_OSVER" in
        16.04)
            # Additional libraries for Python ncclient
            apt-get install -y python-ncclient
        ;;
        *)
            echo "No custom packages for ${FACTER_OSVER}"
        ;;
    esac
}

all_systems() {
    IOTIVITYEXTLIB=/extlibs
    find ${IOTIVITYEXTLIB} -type f -print0 | xargs -0 chmod -R a+rw
    find ${IOTIVITYEXTLIB} -type d -print0 | xargs -0 chmod -R a+rwx
}

echo "---> Detecting OS"
ORIGIN=$(facter operatingsystem | tr '[:upper:]' '[:lower:]')

case "${ORIGIN}" in
    fedora|centos|redhat)
        echo "---> RH type system detected"
        rh_systems
    ;;
    ubuntu)
        echo "---> Ubuntu system detected"
        ubuntu_systems
    ;;
    *)
        echo "---> Unknown operating system"
    ;;
esac

# execute steps for all systems
all_systems
