#!/bin/bash

cd /srv/salt || exit 1
sudo git reset --hard HEAD
sudo git clean -fdx
sudo git pull

sudo salt-call --local state.apply
