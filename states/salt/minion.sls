# NOTE: Do not use pkg.latest here; if Salt upgrades itself during a run things
# fail badly (but recoverably). Always upgrade salt* packages separately,
# independent of all runs.
salt-minion:
  pkg.installed:
    - aggregate: True
  service.dead:
    - enable: False
    - watch:
      - pkg: salt-minion

/etc/salt/gpgkeys:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 500
    - file_mode: 400
    - recurse:
      - user
      - group
      - mode
    - require:
      - pkg: salt-minion
