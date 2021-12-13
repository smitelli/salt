{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:cosmodoc-org:enable_ssl', False)
) %}
{% set version = salt['pillar.get']('website:cosmodoc-org:hugo:version') %}
{% set hash = salt['pillar.get']('website:cosmodoc-org:hugo:hash') %}

include:
  - website

cosmodoc-repo:
  git.latest:
    - name: https://github.com/smitelli/cosmodoc.git
    - branch: main
    - rev: HEAD
    - target: /opt/website/cosmodoc.org
    - user: deploy
    - require:
      - sls: website

cosmodoc-hugo:
  archive.extracted:
    - name: /opt/website/cosmodoc.org/bin
    - source: https://github.com/gohugoio/hugo/releases/download/v{{ version }}/hugo_extended_{{ version }}_Linux-64bit.tar.gz
    - source_hash: {{ hash | yaml_encode }}
    - clean: True
    - user: deploy
    - group: deploy
    - require:
      - git: cosmodoc-repo

cosmodoc-build:
  cmd.run:
    - name: hugo --path-warnings --templateMetrics --baseURL https://cosmodoc.org
    - cwd: /opt/website/cosmodoc.org/src
    - runas: deploy
    - onchanges:
      - git: cosmodoc-repo

/etc/awstats/awstats.cosmodoc.org.conf:
  file.managed:
    - source: salt://website/files/cosmodoc.org/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/cosmodoc.org:
  file.managed:
    - source: salt://website/files/cosmodoc.org/nginx.conf
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
      - git: cosmodoc-repo
      - pkg: nginx

/etc/nginx/sites-enabled/cosmodoc.org:
  file.symlink:
    - target: /etc/nginx/sites-available/cosmodoc.org
    - require:
      - file: /etc/nginx/sites-available/cosmodoc.org

{% if enable_ssl %}
cosmodoc-org-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains cosmodoc.org,www.cosmodoc.org
    - runas: root
    - creates: /etc/letsencrypt/live/cosmodoc.org/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
