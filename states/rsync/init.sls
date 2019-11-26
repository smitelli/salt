rsync:
  pkg.latest

/bin/rrsync:
  file.managed:
    - source: /usr/share/doc/rsync/scripts/rrsync
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: rsync

/usr/bin/rrsync:
  file.managed:
    - source: /usr/share/doc/rsync/scripts/rrsync
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: rsync
