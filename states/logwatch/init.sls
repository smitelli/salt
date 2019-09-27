logwatch:
  pkg.latest

/etc/logwatch/conf/logwatch.conf:
  file.managed:
    - source: salt://logwatch/files/logwatch.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: logwatch
