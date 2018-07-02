include:
  - mariadb.server

twitstash-db-user:
  mysql_user.present:
    - name: twitstash
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True
    - require:
      - service: mariadb
