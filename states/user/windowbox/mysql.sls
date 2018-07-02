include:
  - mariadb.server

windowbox-db-user:
  mysql_user.present:
    - name: windowbox
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True
    - require:
      - service: mariadb
