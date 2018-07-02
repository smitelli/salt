{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:redirects:enable_ssl', False)
) %}

include:
  - website

/etc/nginx/sites-available/redirects:
  file.managed:
    - source: salt://website/files/redirects/nginx.conf
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
      - pkg: nginx

/etc/nginx/sites-enabled/redirects:
  file.symlink:
    - target: /etc/nginx/sites-available/redirects
    - require:
      - file: /etc/nginx/sites-available/redirects

{% if enable_ssl %}
kim559-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --agree-tos --email scott+letsencrypt@smitelli.com
        --non-interactive --standalone --must-staple
        --domains kim559.com,www.kim559.com
    - runas: root
    - creates: /etc/letsencrypt/live/kim559.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot

smitelli-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --agree-tos --email scott+letsencrypt@smitelli.com
        --non-interactive --standalone --must-staple
        --domains smitelli.com,www.smitelli.com,comic.smitelli.com,moblog.smitelli.com,scott.smitelli.com
    - runas: root
    - creates: /etc/letsencrypt/live/smitelli.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot

listen-timsboneyard-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --agree-tos --email scott+letsencrypt@smitelli.com
        --non-interactive --standalone --must-staple
        --domains listen.timsboneyard.com
    - runas: root
    - creates: /etc/letsencrypt/live/listen.timsboneyard.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
