include:
  - mariadb.server

sodasrv-db-user:
  mysql_user.present:
    - name: sodasrv
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True
    - require:
      - service: mariadb
