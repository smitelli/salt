{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:cosmodoc-org:enable_ssl', False)
) %}

include:
  - website

/opt/website/cosmodoc.org:
  file.recurse:
    - source: salt://website/files/cosmodoc.org/webroot
    - clean: True
    - user: deploy
    - group: deploy
    - dir_mode: 755
    - file_mode: 644
    - require:
      - sls: website

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
      - file: /opt/website/cosmodoc.org
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
