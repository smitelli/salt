{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:ivviiv-com:enable_ssl', False)
) %}

include:
  - website

/opt/website/ivviiv.com:
  file.recurse:
    - source: salt://website/files/ivviiv.com/webroot
    - clean: True
    - user: deploy
    - group: deploy
    - dir_mode: 755
    - file_mode: 644
    - require:
      - sls: website

/etc/awstats/awstats.ivviiv.com.conf:
  file.managed:
    - source: salt://website/files/ivviiv.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/ivviiv.com:
  file.managed:
    - source: salt://website/files/ivviiv.com/nginx.conf
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
      - git: ivviiv-com-repo
      - pkg: nginx

/etc/nginx/sites-enabled/ivviiv.com:
  file.symlink:
    - target: /etc/nginx/sites-available/ivviiv.com
    - require:
      - file: /etc/nginx/sites-available/ivviiv.com

{% if enable_ssl %}
ivviiv-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --agree-tos --email scott+letsencrypt@smitelli.com
        --non-interactive --standalone --must-staple
        --domains ivviiv.com,www.ivviiv.com
    - runas: root
    - creates: /etc/letsencrypt/live/ivviiv.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
