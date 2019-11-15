{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:pics-scottsmitelli-com:enable_ssl', False)
) %}

include:
  - website
  - acl
  - cron
  - mariadb.dev-compat
  - mariadb.server
  - perl.image-exiftool
  - python3.pip
  - python3.virtualenv
  - user.windowbox
  - user.windowbox.mysql
  - uwsgi
  - uwsgi.plugin-python3

pics-scottsmitelli-com-repo:
  git.latest:
    - name: https://github.com/smitelli/windowbox.git
    - branch: python3  # TODO
    - rev: python3  # TODO
    - target: /opt/website/pics.scottsmitelli.com
    - user: deploy
    - require:
      - sls: website

# Ensure app has the ability to build its own static files
/opt/website/pics.scottsmitelli.com/windowbox/static:
  acl.present:
    - acl_type: user
    - acl_name: windowbox
    - perms: rwx
    - require:
      - pkg: acl
      - git: pics-scottsmitelli-com-repo
      - user: windowbox

/opt/website/pics.scottsmitelli.com/windowbox/configs/prod.py:
  file.managed:
    - source: salt://website/files/pics.scottsmitelli.com/prod.py
    - template: jinja
    - user: windowbox
    - group: windowbox
    - mode: 400
    - show_changes: False
    - context:
      scheme: {{ 'https' if enable_ssl else 'http' }}
    - require:
      - git: pics-scottsmitelli-com-repo
      - user: windowbox

/var/opt/website/pics.scottsmitelli.com:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - sls: website

/var/opt/website/pics.scottsmitelli.com/.virtualenv:
  file.directory:
    - user: deploy
    - group: deploy
    - mode: 755
    - require:
      - file: /var/opt/website/pics.scottsmitelli.com
  virtualenv.managed:
    - python: /usr/bin/python3
    - pip_pkgs:
      - mysqlclient
    - pip_upgrade: True
    - user: deploy
    - require:
      - file: /var/opt/website/pics.scottsmitelli.com/.virtualenv
      - pkg: libmariadb-dev-compat
      - pkg: python3-pip
      - pkg: virtualenv  # python3 version
  pip.installed:
    - bin_env: /var/opt/website/pics.scottsmitelli.com/.virtualenv
    - editable: /opt/website/pics.scottsmitelli.com
    - upgrade: True
    - user: deploy
    - require:
      - virtualenv: /var/opt/website/pics.scottsmitelli.com/.virtualenv
    - onchanges:
      - git: pics-scottsmitelli-com-repo
    - watch_in:
      - service: uwsgi

pics-scottsmitelli-com-assets:
  cmd.run:
    - name: >
        /var/opt/website/pics.scottsmitelli.com/.virtualenv/bin/flask assets clean;
        /var/opt/website/pics.scottsmitelli.com/.virtualenv/bin/flask assets build
    - runas: windowbox
    - env:
      - WINDOWBOX_CONFIG: /opt/website/pics.scottsmitelli.com/windowbox/configs/prod.py
    - require:
      - acl: /opt/website/pics.scottsmitelli.com/windowbox/static
      - file: /opt/website/pics.scottsmitelli.com/windowbox/configs/prod.py
      - user: windowbox
    - onchanges:
      - pip: /var/opt/website/pics.scottsmitelli.com/.virtualenv

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
    - watch_in:
      - service: cron

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
      - pip: /var/opt/website/pics.scottsmitelli.com/.virtualenv
      - pkg: uwsgi
      - pkg: uwsgi-plugin-python3
      - user: windowbox

/etc/uwsgi/apps-enabled/pics.scottsmitelli.com.ini:
  file.symlink:
    - target: /etc/uwsgi/apps-available/pics.scottsmitelli.com.ini
    - require:
      - file: /etc/uwsgi/apps-available/pics.scottsmitelli.com.ini

pics-scottsmitelli-com-db:
  mysql_database.present:
    - name: windowbox-scottsmitelli
    - character_set: utf8mb4
    - collate: utf8mb4_unicode_ci
    - require:
      - service: mariadb

pics-scottsmitelli-com-db-grant:
  mysql_grants.present:
    - grant: ALL PRIVILEGES
    - database: windowbox-scottsmitelli.*
    - user: windowbox
    - host: localhost
    - require:
      - mysql_database: windowbox-scottsmitelli
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
