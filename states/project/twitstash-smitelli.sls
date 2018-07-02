include:
  - project
  - cron
  - mariadb.server
  - php7-0.bcmath
  - php7-0.cli
  - php7-0.curl
  - php7-0.mysql
  - user.twitstash
  - user.twitstash.mysql
  - project.twanslationparty-engrishsmitelli

twitstash-smitelli-repo:
  git.latest:
    - name: https://github.com/smitelli/twitstash.git
    - branch: master
    - rev: HEAD
    - submodules: True
    - target: /opt/project/twitstash-smitelli
    - user: deploy
    - require:
      - sls: project

/opt/project/twitstash-smitelli/config.ini:
  file.managed:
    - source: salt://project/files/twitstash-smitelli/config.ini
    - template: jinja
    - user: twitstash
    - group: twitstash
    - mode: 400
    - show_changes: False
    - require:
      - git: twitstash-smitelli-repo
      - user: twitstash

/var/log/project/twitstash-smitelli:
  file.directory:
    - user: twitstash
    - group: twitstash
    - mode: 755
    - require:
      - user: twitstash

/etc/cron.d/twitstash-smitelli:
  file.managed:
    - source: salt://project/files/twitstash-smitelli/cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - user: twitstash

/etc/logrotate.d/twitstash-smitelli:
  file.managed:
    - source: salt://project/files/twitstash-smitelli/logrotate
    - user: root
    - group: root
    - mode: 644

twitstash-smitelli-db:
  mysql_database.present:
    - name: twitstash_smitelli
    - character_set: utf8mb4
    - collate: utf8mb4_unicode_ci
    - require:
      - service: mariadb

twitstash-smitelli-db-grant:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: twitstash_smitelli.*
    - user: twitstash
    - host: localhost
    - require:
      - mysql_database: twitstash_smitelli
      - mysql_user: twitstash
