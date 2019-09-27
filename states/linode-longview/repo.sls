linode-longview-repo:
  pkgrepo.managed:
    - humanname: Linode Longview Repository
    - name: deb http://apt-longview.linode.com/ {{ grains['lsb_distrib_codename'] }} main
    - file: /etc/apt/sources.list.d/linode-longview.list
    - key_url: https://apt-longview.linode.com/linode.gpg
