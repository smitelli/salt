#!pyobjects

with Pkg.latest('rsync'):
    File.managed(
        '/bin/rrsync',
        source='/usr/share/doc/rsync/scripts/rrsync', user='root', group='root',
        mode=755)

    File.managed(
        '/usr/bin/rrsync',
        source='/usr/share/doc/rsync/scripts/rrsync', user='root', group='root',
        mode=755)
