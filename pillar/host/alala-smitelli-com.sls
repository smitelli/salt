include:
  - linode-longview.alala-smitelli-com
  - sshd.alala-smitelli-com.private
  - sshd.alala-smitelli-com.public

etc:
  aliases:
    root: scott+root@smitelli.com

fail2ban:
  version: 0.11.2
  hash: d22dacb74509c45ad77e0aafb123936b012e0825
  enable_exim_jail: True
  enable_sshd_jail: True

imagemagick-6:
  policy_width: 25KP
  policy_height: 25KP

logwatch:
  mail_to: logwatch@zcot.net

nftables:
  # NOTE: There is also a Linode firewall running here -- keep them in sync!
  allow_http: True
  allow_https: True
  allow_ping: True
  allow_ssh: True

nginx:
  enable_ssl: True

sshd:
  password_authentication: 'yes'
  # HACK: Relaxed due to FreeNAS bug: https://redmine.ixsystems.com/issues/23872
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
  ssmitelli:
    stow_packages: aliases bash colors editor git htop prompt tmux
