include:
  - salt.minion

/etc/salt/minion.d/00-minion.conf:
  file.managed:
    - source: salt://salt/files/minion.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: salt-minion
