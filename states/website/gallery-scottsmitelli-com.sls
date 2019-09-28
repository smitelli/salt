{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:gallery-scottsmitelli-com:enable_ssl', False)
) %}
{% set in_install_mode = not not salt['pillar.get']('website:gallery-scottsmitelli-com:login_txt', '') %}

include:
  - website
  - dcraw
  - ffmpeg
  - imagemagick-6.q16
  - jhead
  - jpeg.turbo-progs
  - mariadb.server
  - netpbm
  - php.fpm
  - php.gd
  - php.mbstring
  - php.mysql
  - php.xml
  - user.gallery-scottsmitelli-com
  - user.gallery-scottsmitelli-com.mysql
  - zip

/opt/website/gallery.scottsmitelli.com:
  file.directory:
    - user: deploy
    - group: deploy
    - mode: 755
    - require:
      - sls: website

gallery-scottsmitelli-com-repo:
  git.latest:
    - name: https://github.com/smitelli/gallery2.git
    - branch: master
    - rev: HEAD
    - target: /opt/website/gallery.scottsmitelli.com/public
    - user: deploy
    - require:
      - file: /opt/website/gallery.scottsmitelli.com

/opt/website/gallery.scottsmitelli.com/public/config.php:
  file.managed:
    - source: salt://website/files/gallery.scottsmitelli.com/config.php
    - template: jinja
    - user: gallery-scottsmitelli-com
    - group: gallery-scottsmitelli-com
    - show_changes: False
{% if in_install_mode %}
    - mode: 600
    - context:
      setup_password: ''
{% else %}
    - mode: 400
    - context:
      setup_password: {{ salt['pillar.get']('website:gallery-scottsmitelli-com:setup_password') | yaml_encode }}
{% endif %}
      scheme: {{ 'https' if enable_ssl else 'http' }}
    - require:
      - git: gallery-scottsmitelli-com-repo

/opt/website/gallery.scottsmitelli.com/public/login.txt:
{% if in_install_mode %}
  file.managed:
    - contents_pillar: website:gallery-scottsmitelli-com:login_txt
    - user: gallery-scottsmitelli-com
    - group: gallery-scottsmitelli-com
    - mode: 400
    - show_changes: False
{% else %}
  file.absent:
{% endif %}
    - require:
      - git: gallery-scottsmitelli-com-repo

/opt/website/gallery.scottsmitelli.com/public/favicon.ico:
  file.managed:
    - source: salt://website/files/gallery.scottsmitelli.com/favicon.ico
    - user: deploy
    - group: deploy
    - mode: 644
    - require:
      - git: gallery-scottsmitelli-com-repo

/opt/website/gallery.scottsmitelli.com/public/robots.txt:
  file.managed:
    - contents:
      - 'User-agent: *'
      - 'Disallow:'
    - user: deploy
    - group: deploy
    - mode: 644
    - require:
      - git: gallery-scottsmitelli-com-repo

/var/opt/website/gallery.scottsmitelli.com:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - sls: website

/var/opt/website/gallery.scottsmitelli.com/g2data:
  file.directory:
    - user: gallery-scottsmitelli-com
    - group: gallery-scottsmitelli-com
    - mode: 755
    - require:
      - file: /var/opt/website/gallery.scottsmitelli.com
      - user: gallery-scottsmitelli-com

/etc/awstats/awstats.gallery.scottsmitelli.com.conf:
  file.managed:
    - source: salt://website/files/gallery.scottsmitelli.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/gallery.scottsmitelli.com:
  file.managed:
    - source: salt://website/files/gallery.scottsmitelli.com/nginx.conf
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
      - git: gallery-scottsmitelli-com-repo
      - pkg: nginx

/etc/nginx/sites-enabled/gallery.scottsmitelli.com:
  file.symlink:
    - target: /etc/nginx/sites-available/gallery.scottsmitelli.com
    - require:
      - file: /etc/nginx/sites-available/gallery.scottsmitelli.com

/etc/php/current/fpm/pool.d/gallery.scottsmitelli.com.conf:
  file.managed:
    - source: salt://website/files/gallery.scottsmitelli.com/fpm.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm
      - file: /etc/php/current
      - git: gallery-scottsmitelli-com-repo
      - user: gallery-scottsmitelli-com
    - require_in:
      - service: php-fpm

gallery-scottsmitelli-com-db:
  mysql_database.present:
    - name: gallery_scottsmitelli
    - character_set: utf8mb4
    - collate: utf8mb4_unicode_ci
    - require:
      - service: mariadb

gallery-scottsmitelli-com-db-grant:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: gallery_scottsmitelli.*
    - user: gallery-scottsmitelli-com
    - host: localhost
    - require:
      - mysql_database: gallery_scottsmitelli
      - mysql_user: gallery-scottsmitelli-com

{% if enable_ssl %}
gallery-scottsmitelli-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains gallery.scottsmitelli.com
    - runas: root
    - creates: /etc/letsencrypt/live/gallery.scottsmitelli.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
