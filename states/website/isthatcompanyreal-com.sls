{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:isthatcompanyreal-com:enable_ssl', False)
) %}

include:
  - website
  - npm
  - php.fpm
  - user.isthatcompanyreal-com

isthatcompanyreal-com-repo:
  git.latest:
    - name: https://github.com/smitelli/isthatcompanyreal.com.git
    - branch: master
    - rev: HEAD
    - force_fetch: True
    - target: /opt/website/isthatcompanyreal.com
    - user: deploy
    - require:
      - file: /opt/website
      - acl: /opt/website

/opt/website/isthatcompanyreal.com/build.sh:
  cmd.run:
    - runas: deploy
    - require:
      - pkg: npm
    - onchanges:
      - git: isthatcompanyreal-com-repo

/etc/awstats/awstats.isthatcompanyreal.com.conf:
  file.managed:
    - source: salt://website/files/isthatcompanyreal.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/isthatcompanyreal.com:
  file.managed:
    - source: salt://website/files/isthatcompanyreal.com/nginx.conf
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
      - git: isthatcompanyreal-com-repo
      - pkg: nginx

/etc/nginx/sites-enabled/isthatcompanyreal.com:
  file.symlink:
    - target: /etc/nginx/sites-available/isthatcompanyreal.com
    - require:
      - file: /etc/nginx/sites-available/isthatcompanyreal.com

/etc/php/current/fpm/pool.d/isthatcompanyreal.com.conf:
  file.managed:
    - source: salt://website/files/isthatcompanyreal.com/fpm.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm
      - file: /etc/php/current
      - git: isthatcompanyreal-com-repo
      - user: isthatcompanyreal-com
    - require_in:
      - service: php-fpm

{% if enable_ssl %}
isthatcompanyreal-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains isthatcompanyreal.com,www.isthatcompanyreal.com
    - runas: root
    - creates: /etc/letsencrypt/live/isthatcompanyreal.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
