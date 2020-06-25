#!pyobjects

from salt://linode-longview/repo.sls import LONGVIEW_PKGREPO

include('linode-longview.repo')

LONGVIEW_PKG = 'linode-longview'
LONGVIEW_SERVICE = 'longview'

with Pkgrepo(LONGVIEW_PKGREPO):
    with Pkg.latest(LONGVIEW_PKG):
        with Pkg(LONGVIEW_PKG, 'watch'):
            Service.running(LONGVIEW_SERVICE, enable=True)

        with Service(LONGVIEW_SERVICE, 'watch_in'):
            config = pillar(f'linode-longview:{grains("id")}')

            File.managed(
                '/etc/linode/longview.key',
                contents=config['api_key'], user='root', group='root', mode=600,
                show_changes=False)

            if config.get('enable_mysql', False):
                # Works with Debian socket auth; not sure about other distros
                File.managed(
                    '/etc/linode/longview.d/MySQL.conf',
                    contents='username root\npassword ""', user='root',
                    group='root', mode=640)

            if config.get('enable_nginx', False):
                File.managed(
                    '/etc/linode/longview.d/Nginx.conf',
                    contents=f'location {config["nginx_location"]}',
                    user='root', group='root', mode=640)
