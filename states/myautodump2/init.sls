include:
  - cron

/var/lib/myautodump2:
  file.directory:
    - user: root
    - group: root
    - mode: 700

/usr/local/bin/myautodump2:
  file.managed:
    - source: salt://myautodump2/files/myautodump2.sh
    - user: root
    - group: root
    - mode: 755

/etc/cron.d/myautodump2:
  file.managed:
    - source: salt://myautodump2/files/cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - file: /var/lib/myautodump2
      - file: /usr/local/bin/myautodump2
