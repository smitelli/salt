{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:pics-scottsmitelli-com:enable_ssl', False)
) %}

include:
  - website
  - cron
  - gem.sass
  - jpeg.dev
  - mariadb.client-dev
  - mariadb.server
  - npm
  - perl.image-exiftool
  - python.dev
  - python.pip
  - python.virtualenv
  - user.windowbox
  - user.windowbox.mysql
  - uwsgi
  - uwsgi.plugin-python
  - zlib1g.dev
  - project.pics-scottsmitelli-com-barker

pics-scottsmitelli-com-repo:
  git.latest:
    - name: https://github.com/smitelli/windowbox.git
    - branch: master
    - rev: HEAD
    - target: /opt/website/pics.scottsmitelli.com
    - user: deploy
    - require:
      - sls: website

/opt/website/pics.scottsmitelli.com/build.sh:
  cmd.wait:
    - runas: deploy
    - require:
      - pkg: libjpeg-dev
      - pkg: libmariadbclient-dev
      - pkg: npm
      - pkg: zlib1g-dev
    - watch:
      - git: pics-scottsmitelli-com-repo
    - watch_in:
      - service: uwsgi

/opt/website/pics.scottsmitelli.com/src/windowbox/configs/production.cfg:
  file.managed:
    - source: salt://website/files/pics.scottsmitelli.com/production.cfg
    - template: jinja
    - user: windowbox
    - group: windowbox
    - mode: 400
    - show_changes: False
    - require:
      - git: pics-scottsmitelli-com-repo
      - user: windowbox
    - watch_in:
      - service: uwsgi

/var/opt/website/pics.scottsmitelli.com:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - sls: website

/var/opt/website/pics.scottsmitelli.com/attachments:
  file.directory:
    - user: windowbox
    - group: windowbox
    - mode: 755
    - require:
      - file: /var/opt/website/pics.scottsmitelli.com
      - user: windowbox

/var/opt/website/pics.scottsmitelli.com/derivatives:
  file.directory:
    - user: windowbox
    - group: windowbox
    - mode: 755
    - require:
      - file: /var/opt/website/pics.scottsmitelli.com
      - user: windowbox

/var/log/website/pics.scottsmitelli.com:
  file.directory:
    - user: windowbox
    - group: windowbox
    - mode: 755
    - require:
      - sls: website
      - user: windowbox
    - require_in:
      - pkg: uwsgi

/etc/awstats/awstats.pics.scottsmitelli.com.conf:
  file.managed:
    - source: salt://website/files/pics.scottsmitelli.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/cron.d/pics-scottsmitelli-com:
  file.managed:
    - source: salt://website/files/pics.scottsmitelli.com/cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - user: windowbox

/etc/logrotate.d/pics.scottsmitelli.com:
  file.managed:
    - source: salt://website/files/pics.scottsmitelli.com/logrotate
    - user: root
    - group: root
    - mode: 644

/etc/nginx/sites-available/pics.scottsmitelli.com:
  file.managed:
    - source: salt://website/files/pics.scottsmitelli.com/nginx.conf
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
      - git: pics-scottsmitelli-com-repo
      - pkg: nginx

/etc/nginx/sites-enabled/pics.scottsmitelli.com:
  file.symlink:
    - target: /etc/nginx/sites-available/pics.scottsmitelli.com
    - require:
      - file: /etc/nginx/sites-available/pics.scottsmitelli.com

/etc/uwsgi/apps-available/pics.scottsmitelli.com.ini:
  file.managed:
    - source: salt://website/files/pics.scottsmitelli.com/uwsgi.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: uwsgi
      - pkg: uwsgi-plugin-python
      - git: pics-scottsmitelli-com-repo
      - user: windowbox

/etc/uwsgi/apps-enabled/pics.scottsmitelli.com.ini:
  file.symlink:
    - target: /etc/uwsgi/apps-available/pics.scottsmitelli.com.ini
    - require:
      - file: /etc/uwsgi/apps-available/pics.scottsmitelli.com.ini

pics-scottsmitelli-com-db:
  mysql_database.present:
    - name: windowbox_scottsmitelli
    - character_set: utf8mb4
    - collate: utf8mb4_unicode_ci
    - require:
      - service: mariadb

pics-scottsmitelli-com-db-grant:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: windowbox_scottsmitelli.*
    - user: windowbox
    - host: localhost
    - require:
      - mysql_database: windowbox_scottsmitelli
      - mysql_user: windowbox

{% if enable_ssl %}
pics-scottsmitelli-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains pics.scottsmitelli.com
    - runas: root
    - creates: /etc/letsencrypt/live/pics.scottsmitelli.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
