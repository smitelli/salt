include:
  - python3.mysqldb
  - tzdata
  # Opinionated defaults follow:
  - myautodump2
  - mysqltuner

mariadb-server:
  pkg:
    # Installs the maintainer-determined "best" version: 10.5 as of Aug 2022
    - latest
  service.running:
    - name: mariadb
    - enable: True
    - require:
      # The python3-mysqldb package is required for Salt to manipulate database
      # resources. Require it here so other states don't need to worry about it.
      - pkg: python3-mysqldb
    - watch:
      - file: /etc/mysql/mariadb.conf.d/*
      - pkg: mariadb-server

mariadb-tzinfo:
  cmd.run:
    - name: /usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | /usr/bin/mysql mysql
    - runas: root
    - onchanges:
      - pkg: mariadb-server
      - pkg: tzdata
    - require:
      - service: mariadb

# HACK: This is quite broken as of Salt 3004
# https://github.com/saltstack/salt/pull/62169
#root-db-user:
#  mysql_user.present:
#    - name: root
#    - host: localhost
#    - allow_passwordless: True
#    - unix_socket: True
#    - require:
#      - service: mariadb

/etc/mysql/mariadb.conf.d/99-local.cnf:
  file.managed:
    - source: salt://mariadb/files/local.cnf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: mariadb-server
