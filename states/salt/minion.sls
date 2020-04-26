#!pyobjects

SALT_MINION_PKG = SALT_MINION_SERVICE = 'salt-minion'

# NOTE: Do not use Pkg.latest here; if Salt upgrades itself during a run things
# fail badly (but recoverably). Always upgrade salt* packages separately,
# independent of all runs.
with Pkg.installed(SALT_MINION_PKG):
    with Pkg(SALT_MINION_PKG, 'watch'):
        Service.dead(SALT_MINION_SERVICE, enable=False)

    File.directory(
        '/etc/salt/gpgkeys',
        user='root', group='root', dir_mode=500, file_mode=400,
        recurse=['user', 'group', 'mode'])
