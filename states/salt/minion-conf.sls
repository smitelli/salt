#!pyobjects

from salt://salt/minion.sls import SALT_MINION_PKG

include('salt.minion')

File.managed(
    '/etc/salt/minion.d/00-minion.conf',
    source='salt://salt/files/minion.conf', user='root', group='root', mode=644,
    require=Pkg(SALT_MINION_PKG))
