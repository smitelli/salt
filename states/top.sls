base:
  dev-salt:
    #- exim4.zcot-net
    #- fail2ban
    #- iptables
    #- linode-longview
    #- logwatch
    #- ntp
    #- rsync
    - salt.deploy-script
    - salt.minion
    - salt.minion-conf
    #- sshd
    #- sysctl
    #- timezone
    #- user.root
    #- user.ssmitelli
    #- project.sodasrv
    #- project.sort_of_face
    #- project.twitstash-smitelli  # Installs project.twanslationparty-engrishsmitelli
    #- website.alala-smitelli-com
    #- website.dotclockproductions-com
    #- website.gallery-scottsmitelli-com
    #- website.internetstapler-com
    #- website.isthatcompanyreal-com
    #- website.ivviiv-com
    #- website.laurenedman-com
    #- website.pics-scottsmitelli-com
    #- website.scottsmitelli-com
    #- website.thesweetnut-com
    #- website.triggerandfreewheel-com
    #- website.webdav-smitelli-com
    #- website.zcot-net
    #- website.redirects

  alala.smitelli.com:
    - exim4.zcot-net
    - fail2ban
    - iptables
    - linode-longview
    - logwatch
    - ntp
    - rsync
    - salt.deploy-script
    - salt.minion
    - salt.minion-conf
    - sshd
    - sysctl
    - timezone
    - user.root
    - user.ssmitelli
    - project.sodasrv
    - project.sort_of_face
    - project.twitstash-smitelli  # Installs project.twanslationparty-engrishsmitelli
    - website.alala-smitelli-com
    - website.dotclockproductions-com
    - website.gallery-scottsmitelli-com
    - website.internetstapler-com
    - website.isthatcompanyreal-com
    - website.ivviiv-com
    - website.laurenedman-com
    - website.pics-scottsmitelli-com
    - website.scottsmitelli-com
    - website.thesweetnut-com
    - website.triggerandfreewheel-com
    - website.webdav-smitelli-com
    - website.zcot-net
    - website.redirects
