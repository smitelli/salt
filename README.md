Salt
====

The Salt states that underpin... well... pretty much everything.

by [Scott Smitelli](mailto:scott@smitelli.com)

Ye Olde Quicke Starte
=====================

All the below commands assume the user is already root.

    hostnamectl set-hostname hostname.fqdn.com
    reboot

    cd $(mktemp -d)
    wget -O bootstrap-salt.sh https://raw.githubusercontent.com/saltstack/salt-bootstrap/v2019.05.20/bootstrap-salt.sh
    sha256sum bootstrap-salt.sh
    # verify 46fb5e4b7815efafd69fd703f033fe86e7b584b6770f7e0b936995bcae1cedd8
    chmod +x bootstrap-salt.sh
    ./bootstrap-salt.sh -X -F -c /tmp

    mkdir -p /etc/salt/gpgkeys /srv/salt
    # install {pub,sec}ring.gpg into /etc/salt/gpgkeys/
    # install ./ into /srv/salt/
    cp /srv/salt/states/salt/files/minion.conf /etc/salt/minion.d/00-minion.conf
    salt-call --log-level=info --local state.apply

### Using the Vagrant environment:

    vagrant up

That's really all there is to it. By default no interesting states/pillars are
loaded, the GPG keys are missing, and the guest VM doesn't do anything useful.
Presumably you know what you want to do and how to accomplish it.

The `Vagrantfile` uses port 80 on the host for the guest's web server, which
some OSes may not like.

### Run states:

    sudo salt-call --local state.apply

### Meaningful data may be stored in any of the following locations:

* /var/lib/awstats
* /var/lib/myautodump2
* /var/lib/mysql
* /var/opt/project
* /var/opt/website

### Create a brand-new key pair (this requires redoing all the pillar encryption):

    gpg --homedir /etc/salt/gpgkeys --gen-key

* Key type: RSA and RSA
* Key size: 4096
* Key is valid for: 0 (does not expire)
* Real name: salt@smitelli.com
* Email address: salt@smitelli.com
* Comment: [empty]
* Passphrase: [empty]

### Encode a secret (make *sure* you consider if you want or don't want `-n`):

    echo -n 'SECRET' | sudo gpg --homedir /etc/salt/gpgkeys --armor --batch \
        --trust-model always --encrypt -r salt@smitelli.com

### Create an `/etc/shadow` password hash:

    openssl passwd -1  # MD5
    mkpasswd --method=sha-512  # SHA-512

### Create SSH keypairs:

    ssh-keygen -o -t ed25519 -f ...
    ssh-keygen -o -t rsa -b 2048 -f ...
    ssh-keygen -o -t ecdsa -b 521 -f ...

### TODOs:

* Go through EVERY SINGLE include and requisite to make sure states are atomic
* Check that each project/website works in isolation
* switch from cmd.wait/watch to cmd.run/onchanges
* Check each website in HTTP-only config
* homedir dotfiles
* icinga2: https://blog.sleeplessbeastie.eu/2018/01/15/how-to-install-icinga2-and-icingaweb2/
* ...or NetData: https://www.netdata.cloud/
* Content-Security-Policy and Feature-Policy for each website
* When nginx 1.14 is available:
    - Update TLS versions and ciphers
    - Change all 301 redirects to 308
* TnF needs UTC conversion :(
