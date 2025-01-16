{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:scottsmitelli-com:enable_ssl', False)
) %}
{% set version = salt['pillar.get']('website:scottsmitelli-com:hugo:version') %}
{% set hash = salt['pillar.get']('website:scottsmitelli-com:hugo:hash') %}

include:
  - website

scottsmitelli-com-repo:
  git.latest:
    - name: https://github.com/smitelli/scottsmitelli.com.git
    - branch: master
    - rev: HEAD
    - force_fetch: True
    - target: /opt/website/scottsmitelli.com
    - user: deploy
    - require:
      - file: /opt/website
      - acl: /opt/website

scottsmitelli-com-hugo:
  archive.extracted:
    - name: /opt/website/scottsmitelli.com/bin
    - source: https://github.com/gohugoio/hugo/releases/download/v{{ version }}/hugo_extended_{{ version }}_Linux-64bit.tar.gz
    - source_hash: {{ hash | yaml_encode }}
    - clean: True
    - enforce_toplevel: False
    - user: deploy
    - group: deploy
    - require:
      - git: scottsmitelli-com-repo

scottsmitelli-com-build:
  cmd.run:
    - name: >
        git clean -fdx ../public;
        rm -rf /home/deploy/.cache/hugo_cache;
        /opt/website/scottsmitelli.com/bin/hugo --printPathWarnings --printUnusedTemplates --templateMetrics --baseURL https://www.scottsmitelli.com
    - cwd: /opt/website/scottsmitelli.com/src
    - runas: deploy
    - onchanges:
      - git: scottsmitelli-com-repo
      - archive: scottsmitelli-com-hugo

/etc/awstats/awstats.scottsmitelli.com.conf:
  file.managed:
    - source: salt://website/files/scottsmitelli.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/scottsmitelli.com:
  file.managed:
    - source: salt://website/files/scottsmitelli.com/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      enable_ssl: {{ enable_ssl | yaml_encode }}
      cache_max_age: 4M
    - require:
{% if enable_ssl %}
      - file: /etc/nginx/conf.d/ssl.conf
{% endif %}
      - git: scottsmitelli-com-repo
      - pkg: nginx

/etc/nginx/sites-enabled/scottsmitelli.com:
  file.symlink:
    - target: /etc/nginx/sites-available/scottsmitelli.com
    - require:
      - file: /etc/nginx/sites-available/scottsmitelli.com

{% if enable_ssl %}
scottsmitelli-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains scottsmitelli.com,www.scottsmitelli.com
    - runas: root
    - creates: /etc/letsencrypt/live/scottsmitelli.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
