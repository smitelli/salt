{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:triggerandfreewheel-com:enable_ssl', False)
) %}

include:
  - website
  - cron
  - fail2ban
  - mariadb.server
  - php.cli
  - php.curl
  - php.fpm
  - php.mysql
  - user.triggerandfreewheel-com
  - user.triggerandfreewheel-com.mysql

triggerandfreewheel-com-repo:
  git.latest:
    - name: https://github.com/smitelli/triggerandfreewheel.com.git
    - branch: master
    - rev: HEAD
    - target: /opt/website/triggerandfreewheel.com
    - user: deploy
    - require:
      - file: /opt/website
      - acl: /opt/website

/opt/website/triggerandfreewheel.com/src/classes/class.Config.php:
  file.managed:
    - source: salt://website/files/triggerandfreewheel.com/config.php
    - template: jinja
    - user: triggerandfreewheel-com
    - group: triggerandfreewheel-com
    - mode: 400
    - show_changes: False
    - require:
      - git: triggerandfreewheel-com-repo
      - user: triggerandfreewheel-com

/var/opt/website/triggerandfreewheel.com:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /var/opt/website

/var/opt/website/triggerandfreewheel.com/compile:
  file.directory:
    - user: triggerandfreewheel-com
    - group: triggerandfreewheel-com
    - mode: 755
    - require:
      - file: /var/opt/website/triggerandfreewheel.com
      - user: triggerandfreewheel-com

/var/opt/website/triggerandfreewheel.com/extras:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: /var/opt/website/triggerandfreewheel.com

/var/opt/website/triggerandfreewheel.com/uploads:
  file.directory:
    - user: triggerandfreewheel-com
    - group: triggerandfreewheel-com
    - mode: 755
    - require:
      - file: /var/opt/website/triggerandfreewheel.com
      - user: triggerandfreewheel-com

/var/log/website/triggerandfreewheel.com:
  file.directory:
    - user: triggerandfreewheel-com
    - group: triggerandfreewheel-com
    - mode: 755

/etc/awstats/awstats.triggerandfreewheel.com.conf:
  file.managed:
    - source: salt://website/files/triggerandfreewheel.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/cron.d/triggerandfreewheel-com:
  file.managed:
    - source: salt://website/files/triggerandfreewheel.com/cron
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - user: triggerandfreewheel-com
    - watch_in:
      - service: cron

/etc/fail2ban/filter.d/triggerandfreewheel-com.conf:
  file.managed:
    - source: salt://website/files/triggerandfreewheel.com/fail2ban-filter.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: fail2ban
    - watch_in:
      - service: fail2ban

/etc/fail2ban/jail.d/triggerandfreewheel-com.conf:
  file.managed:
    - source: salt://website/files/triggerandfreewheel.com/fail2ban-jail.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - service: nginx
      - file: /etc/fail2ban/filter.d/triggerandfreewheel-com.conf
      - file: /etc/nginx/sites-enabled/triggerandfreewheel.com
    - watch_in:
      - service: fail2ban

/etc/logrotate.d/triggerandfreewheel.com:
  file.managed:
    - source: salt://website/files/triggerandfreewheel.com/logrotate
    - user: root
    - group: root
    - mode: 644

/etc/nginx/sites-available/triggerandfreewheel.com:
  file.managed:
    - source: salt://website/files/triggerandfreewheel.com/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      enable_ssl: {{ enable_ssl | yaml_encode }}
    - require:
{% if enable_ssl %}
      - file: /etc/nginx/conf.d/ssl.conf
{% endif %}
      - git: triggerandfreewheel-com-repo
      - pkg: nginx

/etc/nginx/sites-enabled/triggerandfreewheel.com:
  file.symlink:
    - target: /etc/nginx/sites-available/triggerandfreewheel.com
    - require:
      - file: /etc/nginx/sites-available/triggerandfreewheel.com

/etc/php/current/fpm/pool.d/triggerandfreewheel.com.conf:
  file.managed:
    - source: salt://website/files/triggerandfreewheel.com/fpm.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm
      - file: /etc/php/current
      - git: triggerandfreewheel-com-repo
      - user: triggerandfreewheel-com
    - require_in:
      - service: php-fpm

triggerandfreewheel-com-db:
  mysql_database.present:
    - name: triggerandfreewheel
    - character_set: utf8mb4
    - collate: utf8mb4_unicode_520_ci
    - require:
      - service: mariadb

triggerandfreewheel-com-db-grant:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: triggerandfreewheel.*
    - user: triggerandfreewheel-com
    - host: localhost
    - require:
      - mysql_database: triggerandfreewheel
      - mysql_user: triggerandfreewheel-com

{% if enable_ssl %}
triggerandfreewheel-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains triggerandfreewheel.com,www.triggerandfreewheel.com
    - runas: root
    - creates: /etc/letsencrypt/live/triggerandfreewheel.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
