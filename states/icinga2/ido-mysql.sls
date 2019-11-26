include:
  - icinga2
  - mariadb.server
  - user.nagios.mysql

icinga2-ido-mysql:
  pkg.latest:
    - require:
      - pkg: icinga2
      - service: mariadb

/etc/icinga2/features-available/ido-mysql.conf:
  file.managed:
    - source: salt://icinga2/files/ido-mysql.conf
    - user: nagios
    - group: nagios
    - mode: 400
    - show_changes: False
    - require:
      - pkg: icinga2-ido-mysql

/etc/icinga2/features-enabled/ido-mysql.conf:
  file.symlink:
    - target: /etc/icinga2/features-available/ido-mysql.conf
    - require:
      - file: /etc/icinga2/features-available/ido-mysql.conf

icinga2-db:
  mysql_database.present:
    - name: icinga2
    - character_set: utf8mb4
    - collate: utf8mb4_unicode_ci
    - require:
      - pkg: icinga2-ido-mysql

icinga2-db-grant:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: icinga2.*
    - user: nagios
    - host: localhost
    - require:
      - mysql_database: icinga2
      - mysql_user: nagios

  mysql_user.absent:
    - name: icinga2
    - require:
      - mysql_database: icinga2
