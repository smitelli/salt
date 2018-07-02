include:
  - linode-longview.alala-smitelli-com
  - sshd.alala-smitelli-com.private
  - sshd.alala-smitelli-com.public

etc:
  aliases:
    root: scott+root@smitelli.com

fail2ban:
  version: 0.10.3.1
  hash: 126c7f46dd12504456b61bcf3309503735ce236f
  enable_exim_jail: True
  enable_sshd_jail: True

imagemagick-6:
  policy_width: 25KP
  policy_height: 25KP

iptables:
  v4:
    allow_http: True
    allow_https: True
    allow_ping: True
    allow_smtp: True
    allow_ssh: True
  v6:
    allow_http: True
    allow_https: True
    allow_smtp: True
    allow_ssh: True

logwatch:
  mail_to: logwatch@zcot.net

nginx:
  enable_ssl: True

node:
  install_from_ppa: True
  ppa:
    repository_url: https://deb.nodesource.com/node_8.x

sshd:
  password_authentication: 'yes'
  # Relaxed due to FreeNAS bug: https://redmine.ixsystems.com/issues/23872
  # permit_root_login: forced-commands-only
  permit_root_login: prohibit-password

sysctl:
  net.ipv4.conf.all.rp_filter: 1
  vm.swappiness: 0

timezone:
  name: America/New_York
  utc: True

user:
  root:
    enable_ssh_auth_canyonero: True
