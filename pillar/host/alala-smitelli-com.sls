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

logwatch:
  mail_to: logwatch@zcot.net

nftables:
  allow_http: True
  allow_https: True
  allow_ping: True
  allow_smtp: True
  allow_ssh: True

nginx:
  enable_ssl: True

sshd:
  password_authentication: 'yes'
  # Relaxed due to FreeNAS bug: https://redmine.ixsystems.com/issues/23872
  # permit_root_login: forced-commands-only
  permit_root_login: prohibit-password

sysctl:
  net.ipv4.conf.all.rp_filter: 1
  vm.swappiness: 0

timezone:
  name: Etc/UTC
  utc: True

user:
  root:
    enable_ssh_auth_canyonero: True
