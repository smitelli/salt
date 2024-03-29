base:
  dev-salt:
    - salt.deploy-script
    - salt.minion
    - salt.minion-conf

  alala.smitelli.com:
    - exim4.daemon-light
    - fail2ban
    - htop
    - linode-longview
    - logwatch
    - nftables
    - ntp
    - rsync
    - salt.deploy-script
    - salt.minion
    - salt.minion-conf
    - sshd
    - sysctl
    - timezone
    - user.ledman
    - user.root
    - user.ssmitelli
    - website.alala-smitelli-com
    - website.cosmodoc-org
    - website.dotclockproductions-com
    - website.gallery-scottsmitelli-com
    - website.internetstapler-com
    - website.isthatcompanyreal-com
    - website.ivviiv-com
    - website.laurenedman-com
    - website.northernflickermusic-com
    - website.pics-scottsmitelli-com
    - website.scottsmitelli-com
    - website.thesweetnut-com
    - website.triggerandfreewheel-com
    - website.webdav-smitelli-com
    - website.zcot-net
    - website.redirects
