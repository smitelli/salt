#!pyobjects

LONGVIEW_PKGREPO = f'deb https://apt-longview.linode.com/ {grains("lsb_distrib_codename")} main'

Pkgrepo.managed(
    LONGVIEW_PKGREPO,
    humanname='Linode Longview Repository',
    file='/etc/apt/sources.list.d/linode-longview.list',
    key_url='https://apt-longview.linode.com/linode.gpg')
