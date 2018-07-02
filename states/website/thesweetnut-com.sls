{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:thesweetnut-com:enable_ssl', False)
) %}

include:
  - website

thesweetnut-com-repo:
  git.latest:
    - name: https://github.com/smitelli/thesweetnut.com.git
    - branch: master
    - rev: HEAD
    - target: /opt/website/thesweetnut.com
    - user: deploy
    - require:
      - sls: website

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
      - git: thesweetnut-com-repo
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
        /usr/local/bin/certbot certonly --agree-tos --email scott+letsencrypt@smitelli.com
        --non-interactive --standalone --must-staple
        --domains thesweetnut.com,www.thesweetnut.com
    - runas: root
    - creates: /etc/letsencrypt/live/thesweetnut.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
