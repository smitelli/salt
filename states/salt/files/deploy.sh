#!/bin/bash

cd /srv/salt || exit 1

# Wrap this in a guard so we don't accidentally whack a Vagrant host's workdir
mount | grep 'type vboxsf' > /dev/null || (
    sudo git clean -fdx
    sudo git reset --hard HEAD
    sudo git pull --ff-only
)

sudo salt-call --local state.apply
