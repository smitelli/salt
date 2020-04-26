#!pyobjects

File.managed(
    '/usr/local/bin/deploy',
    source='salt://salt/files/deploy.sh', user='root', group='root', mode=755)
