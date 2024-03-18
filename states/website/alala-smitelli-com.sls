{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:alala-smitelli-com:enable_ssl', False)
) %}

include:
  - website

/opt/website/alala.smitelli.com:
  file.recurse:
    - source: salt://website/files/alala.smitelli.com/webroot
    - clean: True
    - user: deploy
    - group: deploy
    - dir_mode: 755
    - file_mode: 644
    - require:
      - file: /opt/website
      - acl: /opt/website

/etc/awstats/awstats.alala.smitelli.com.conf:
  file.managed:
    - source: salt://website/files/alala.smitelli.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/alala.smitelli.com:
  file.managed:
    - source: salt://website/files/alala.smitelli.com/nginx.conf
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
      - file: /opt/website/alala.smitelli.com
      - pkg: nginx

/etc/nginx/sites-enabled/alala.smitelli.com:
  file.symlink:
    - target: /etc/nginx/sites-available/alala.smitelli.com
    - require:
      - file: /etc/nginx/sites-available/alala.smitelli.com

{% if enable_ssl %}
alala-smitelli-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains alala.smitelli.com
    - runas: root
    - creates: /etc/letsencrypt/live/alala.smitelli.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
