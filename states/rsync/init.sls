rsync:
  pkg.latest

rrsync:
  cmd.run:
    - name: cp /usr/share/doc/rsync/scripts/rrsync /usr/local/bin/rrsync
    - unless: '[ -s /usr/local/bin/rrsync ]'
    - runas: root
    - require:
      - pkg: rsync

/usr/local/bin/rrsync:
  file.managed:
    - replace: False
    - user: root
    - group: root
    - mode: 755
    - watch:
      - cmd: rrsync

/usr/bin/rrsync:
  file.symlink:
    - target: /usr/local/bin/rrsync
    - require:
      - file: /usr/local/bin/rrsync
