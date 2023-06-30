linode-longview-repo:
  pkgrepo.managed:
    - humanname: Linode Longview Repository
    # TODO HACK FIXME
    #- name: deb https://apt-longview.linode.com/ {{ grains['oscodename'] }} main
    - name: deb https://apt-longview.linode.com/ bullseye main
    - file: /etc/apt/sources.list.d/linode-longview.list
    - key_url: https://apt-longview.linode.com/linode.gpg
