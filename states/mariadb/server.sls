include:
  - myautodump2
  - python3.mysqldb

# Installs the maintainer-determined "best" version: 10.3 as of this writing
mariadb-server:
  pkg:
    - latest
  service.running:
    - name: mariadb
    - enable: True
    - require:
      # The python3-mysqldb package is required for Salt to manipulate database
      # resources. Require it here so other states don't need to worry about it.
      - pkg: python3-mysqldb
    - watch:
      - pkg: mariadb-server

root-db-user:
  mysql_user.present:
    - name: root
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True
    - require:
      - service: mariadb
