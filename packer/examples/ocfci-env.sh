#!/bin/bash -e

#sudo apt-get install -q -q -y python2.7-dev python-virtualenv

# mkdir -p ~/tmp
# wget -O ~/tmp/packer_1.0.3_linux_amd64.zip https://releases.hashicorp.com/packer/1.0.3/packer_1.0.3_linux_amd64.zip
# unzip -d ~/bin ~/tmp/packer_1.0.3_linux_amd64.zip

OS_INSTANCE=${OS_INSTANCE:-ocfci}
CREDENTIALS_URL=${CREDENTIALS_URL:-https://secure.vexxhost.com/console/#/account/credentials}

VIRTUALENV=${VIRTUALENV:-${HOME}/src/virtualenv/openstack.${OS_INSTANCE}}

function source_credentials {
    mkdir -p ${VIRTUALENV}/etc
    local OS_CREDENTIALS=${VIRTUALENV}/etc/openstack-credentials
    if [ -f ${OS_CREDENTIALS} ]
    then
        source ${OS_CREDENTIALS}
    else
        echo "Please place openstack credentials in file /tmp/ocf-vexx-env.sh for copy to ${OS_CREDENTIALS}"
        echo "For specifics, see ${CREDENTIALS_URL}"
        echo "Press <enter> when finished"
        read

        cp /tmp/ocf-vexx-env.sh ${OS_CREDENTIALS}

        source ${OS_CREDENTIALS}
    fi
}

source_credentials

ENV_PATH="${VIRTUALENV}/bin"
ENV_LIB="${VIRTUALENV}/lib"
PERL5LIB="${ENV_LIB}/perl5"
#RUBYLIB="${ENV_LIB}"

echo "creating python local lib"
virtualenv --prompt="(${OS_INSTANCE})" -q ${VIRTUALENV}

PATH="${ENV_PATH}:$PATH"
#RUBYPATH="$PATH"

#echo "creating/updating perl local lib"
#eval "$(perl -I${VIRTUALENV} -Mlocal::lib=$VIRTUALENV)"
#cpanm -l ${VIRTUALENV} install OpenStack::Client::Auth JSON::XS Data::UUID URI

#echo "creating/updating ruby local lib"
#eval "$(rbenv init -)"
#rbenv local 2.1.5
#rbenv global 2.1.5

echo "updating python local lib"
source ${VIRTUALENV}/bin/activate
pip install -q --upgrade pip
pip install -q --upgrade setuptools
pip install -q --upgrade lftools

export OS_INSTANCE PATH PERL5LIB #RUBYPATH RUBYLIB
