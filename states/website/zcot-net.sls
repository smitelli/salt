{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:zcot-net:enable_ssl', False)
) %}

include:
  - website

/opt/website/zcot.net:
  file.recurse:
    - source: salt://website/files/zcot.net/webroot
    - clean: True
    - user: deploy
    - group: deploy
    - dir_mode: 755
    - file_mode: 644
    - require:
      - sls: website

/etc/awstats/awstats.zcot.net.conf:
  file.managed:
    - source: salt://website/files/zcot.net/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/zcot.net:
  file.managed:
    - source: salt://website/files/zcot.net/nginx.conf
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
      - file: /opt/website/zcot.net
      - pkg: nginx

/etc/nginx/sites-enabled/zcot.net:
  file.symlink:
    - target: /etc/nginx/sites-available/zcot.net
    - require:
      - file: /etc/nginx/sites-available/zcot.net

{% if enable_ssl %}
zcot-net-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --agree-tos --email scott+letsencrypt@smitelli.com
        --non-interactive --standalone --must-staple
        --domains zcot.net,mx.zcot.net,www.zcot.net
    - runas: root
    - creates: /etc/letsencrypt/live/zcot.net/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
