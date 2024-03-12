{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:thesweetnut-com:enable_ssl', False)
) %}

include:
  - website

/opt/website/thesweetnut.com:
  file.recurse:
    - source: salt://website/files/thesweetnut.com/webroot
    - clean: True
    - user: deploy
    - group: deploy
    - dir_mode: 755
    - file_mode: 644
    #- require:
    #  - sls: website TODO huh?

/etc/awstats/awstats.thesweetnut.com.conf:
  file.managed:
    - source: salt://website/files/thesweetnut.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/thesweetnut.com:
  file.managed:
    - source: salt://website/files/thesweetnut.com/nginx.conf
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
      - file: /opt/website/thesweetnut.com
      - pkg: nginx

/etc/nginx/sites-enabled/thesweetnut.com:
  file.symlink:
    - target: /etc/nginx/sites-available/thesweetnut.com
    - require:
      - file: /etc/nginx/sites-available/thesweetnut.com

{% if enable_ssl %}
thesweetnut-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains thesweetnut.com,www.thesweetnut.com
    - runas: root
    - creates: /etc/letsencrypt/live/thesweetnut.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
