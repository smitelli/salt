/usr/local/bin/deploy:
  file.managed:
    - source: salt://salt/files/deploy.sh
    - user: root
    - group: root
    - mode: 755
