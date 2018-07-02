include:
  - mariadb.server

nagios-db-user:
  mysql_user.present:
    - name: nagios
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True
    - require:
      - service: mariadb
