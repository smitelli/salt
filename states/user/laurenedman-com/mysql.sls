include:
  - mariadb.server

laurenedman-com-db-user:
  mysql_user.present:
    - name: laurenedman-com
    - host: localhost
    - allow_passwordless: True
    - unix_socket: True
    - require:
      - service: mariadb
