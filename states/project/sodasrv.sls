# Sodasrv technically straddles the line between a project and a website.
# At present time, I'm including it under `project` because it does not yet have
# a dedicated nginx server which hosts it. Please look at the state files for
# `alala.smitelli.com` and the URL path `/sodasrv` to see what happens on the
# other end of the FPM socket file.

include:
  - project
  - mariadb.server
  - php.fpm
  - php.mysql
  - user.sodasrv
  - user.sodasrv.mysql

sodasrv-repo:
  git.latest:
    - name: https://github.com/smitelli/sodasrv.git
    - branch: master
    - rev: HEAD
    - target: /opt/project/sodasrv
    - user: deploy
    - require:
      - sls: project

/opt/project/sodasrv/src/includes/config.php:
  file.managed:
    - source: salt://project/files/sodasrv/config.php
    - template: jinja
    - user: sodasrv
    - group: sodasrv
    - mode: 400
    - show_changes: False
    - require:
      - git: sodasrv-repo
      - user: sodasrv

/var/opt/project/sodasrv:
  file.directory:
    - user: sodasrv
    - group: sodasrv
    - mode: 755
    - require:
      - sls: project
      - user: sodasrv

/var/opt/project/sodasrv/compile:
  file.directory:
    - user: sodasrv
    - group: sodasrv
    - mode: 755
    - require:
      - file: /var/opt/project/sodasrv

/etc/php/current/fpm/pool.d/sodasrv.conf:
  file.managed:
    - source: salt://project/files/sodasrv/fpm.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm
      - file: /etc/php/current
      - git: sodasrv-repo
      - user: sodasrv
    - require_in:
      - service: php-fpm

sodasrv-db:
  mysql_database.present:
    - name: sodasrv
    - character_set: utf8mb4
    - collate: utf8mb4_unicode_ci
    - require:
      - service: mariadb

sodasrv-db-grant:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: sodasrv.*
    - user: sodasrv
    - host: localhost
    - require:
      - mysql_database: sodasrv
      - mysql_user: sodasrv
