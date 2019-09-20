{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:laurenedman-com:enable_ssl', False)
) %}

include:
  - website
  - cron
  - fail2ban
  - mariadb.server
  - php7-0.cli
  - php7-0.fpm
  - php7-0.gd
  - php7-0.mysql
  - user.laurenedman-com
  - user.laurenedman-com.mysql

/var/opt/website/laurenedman.com:
  file.directory:
    - user: deploy
    - group: deploy
    - mode: 755
    - require:
      - sls: website

/var/opt/website/laurenedman.com/public:
  file.directory:
    - user: laurenedman-com
    - group: laurenedman-com
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - require:
      - file: /var/opt/website/laurenedman.com
      - user: laurenedman-com

/var/opt/website/laurenedman.com/public/google8a70a3077158ac03.html:
  file.managed:
    - contents: 'google-site-verification: google8a70a3077158ac03.html'
    - contents_newline: False
    - user: laurenedman-com
    - group: laurenedman-com
    - mode: 644
    - require:
      - file: /var/opt/website/laurenedman.com/public

/var/opt/website/laurenedman.com/public/robots.txt:
  file.managed:
    - contents:
      - 'User-agent: *'
      - 'Disallow:'
    - user: laurenedman-com
    - group: laurenedman-com
    - mode: 644
    - require:
      - file: /var/opt/website/laurenedman.com/public

/var/opt/website/laurenedman.com/public/wp-config.php:
  file.managed:
    - source: salt://website/files/laurenedman.com/wp-config.php
    - template: jinja
    - user: laurenedman-com
    - group: laurenedman-com
    - mode: 644
    - show_changes: False
    - require:
      - file: /var/opt/website/laurenedman.com/public

/etc/awstats/awstats.laurenedman.com.conf:
  file.managed:
    - source: salt://website/files/laurenedman.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/cron.d/laurenedman-com:
  file.managed:
    - source: salt://website/files/laurenedman.com/cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - user: laurenedman-com

/etc/fail2ban/filter.d/laurenedman-com.conf:
  file.managed:
    - source: salt://website/files/laurenedman.com/fail2ban-filter.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: fail2ban-install

/etc/fail2ban/jail.d/laurenedman-com.conf:
  file.managed:
    - source: salt://website/files/laurenedman.com/fail2ban-jail.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - service: nginx
      - file: /etc/fail2ban/filter.d/laurenedman-com.conf
      - file: /etc/nginx/sites-enabled/laurenedman.com

/etc/nginx/sites-available/laurenedman.com:
  file.managed:
    - source: salt://website/files/laurenedman.com/nginx.conf
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
      - file: /var/opt/website/laurenedman.com/public
      - pkg: nginx

/etc/nginx/sites-enabled/laurenedman.com:
  file.symlink:
    - target: /etc/nginx/sites-available/laurenedman.com
    - require:
      - file: /etc/nginx/sites-available/laurenedman.com

/etc/php/7.0/fpm/pool.d/laurenedman.com.conf:
  file.managed:
    - source: salt://website/files/laurenedman.com/fpm.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php7.0-fpm
      - file: /var/opt/website/laurenedman.com
      - user: laurenedman-com

laurenedman-com-db:
  mysql_database.present:
    - name: laurenedman
    - character_set: utf8mb4
    - collate: utf8mb4_unicode_ci
    - require:
      - service: mariadb

laurenedman-com-db-grant:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: laurenedman.*
    - user: laurenedman-com
    - host: localhost
    - require:
      - mysql_database: laurenedman
      - mysql_user: laurenedman-com

{% if enable_ssl %}
laurenedman-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains laurenedman.com,www.laurenedman.com
    - runas: root
    - creates: /etc/letsencrypt/live/laurenedman.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
