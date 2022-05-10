Salt
====

The Salt states that underpin... well... pretty much everything.

by [Scott Smitelli](mailto:scott@smitelli.com)

Ye Olde Quicke Starte
=====================

All the below commands assume the user is already root.

```bash
hostnamectl set-hostname hostname.fqdn.com
reboot

cd $(mktemp -d)
curl -o bootstrap-salt.sh -L https://bootstrap.saltproject.io
sh bootstrap-salt.sh -X -x python3 -F -c /tmp

mkdir -p /etc/salt/gpgkeys /srv/salt
# install {pub,sec}ring.gpg into /etc/salt/gpgkeys/
# install ./ into /srv/salt/
cp /srv/salt/states/salt/files/minion.conf /etc/salt/minion.d/00-minion.conf
salt-call --log-level=info --local state.apply
```

### Using the Vagrant environment:

```bash
vagrant up
```

That's really all there is to it. By default no interesting states/pillars are
loaded, the GPG keys are missing, and the guest VM doesn't do anything useful.
Presumably you know what you want to do and how to accomplish it.

The Vagrantfile uses port 80 on the host for the guest's web server, which some
host OSes may not like.

### Run states:

```bash
sudo salt-call --local state.apply
```

### Meaningful data may be stored in any of the following locations:

* /etc/letsencrypt
* /var/lib/awstats
* /var/lib/myautodump2
* /var/lib/mysql
* /var/opt/project
* /var/opt/website

### Create a brand-new key pair (this requires redoing all the pillar encryption):

```bash
gpg --homedir /etc/salt/gpgkeys --gen-key
```

* Key type: RSA and RSA
* Key size: 4096
* Key is valid for: 0 (does not expire)
* Real name: salt@smitelli.com
* Email address: salt@smitelli.com
* Comment: [empty]
* Passphrase: [empty]

### Encode a secret (make *sure* you consider if you want or don't want `-n`):

```bash
echo -n 'SECRET' | sudo gpg --homedir /etc/salt/gpgkeys --armor --batch --trust-model always --encrypt -r salt@smitelli.com
```

### Create an /etc/shadow password hash:

```bash
openssl passwd -1  # MD5
openssl passwd -6  # SHA-512
```

### Create SSH keypairs:

```bash
ssh-keygen -o -t ed25519 -f ...
ssh-keygen -o -t rsa -b 2048 -f ...
ssh-keygen -o -t ecdsa -b 521 -f ...
```

### TODOs:

* Content-Security-Policy and Feature-Policy for each website
* Go through EVERY SINGLE include and requisite to make sure states are atomic
* Check that each project/website works in isolation
* icinga2: https://blog.sleeplessbeastie.eu/2018/01/15/how-to-install-icinga2-and-icingaweb2/
* ...or NetData: https://www.netdata.cloud/
* gallery throws deprecation warnings on install
* TnF smarty version has a deprecation warning
