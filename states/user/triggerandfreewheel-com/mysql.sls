include:
  - mariadb.server

triggerandfreewheel-com-db-user:
  mysql_user.present:
    - name: triggerandfreewheel-com
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True
    - require:
      - service: mariadb
