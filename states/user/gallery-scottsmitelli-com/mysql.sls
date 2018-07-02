include:
  - mariadb.server

gallery-scottsmitelli-com-db-user:
  mysql_user.present:
    - name: gallery-scottsmitelli-com
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True
    - require:
      - service: mariadb
