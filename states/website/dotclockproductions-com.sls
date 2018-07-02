{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:dotclockproductions-com:enable_ssl', False)
) %}

include:
  - website

dotclockproductions-com-repo:
  git.latest:
    - name: https://github.com/smitelli/dotclockproductions.com.git
    - branch: master
    - rev: HEAD
    - target: /opt/website/dotclockproductions.com
    - user: deploy
    - require:
      - sls: website

/etc/awstats/awstats.dotclockproductions.com.conf:
  file.managed:
    - source: salt://website/files/dotclockproductions.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/dotclockproductions.com:
  file.managed:
    - source: salt://website/files/dotclockproductions.com/nginx.conf
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
      - git: dotclockproductions-com-repo
      - pkg: nginx

/etc/nginx/sites-enabled/dotclockproductions.com:
  file.symlink:
    - target: /etc/nginx/sites-available/dotclockproductions.com
    - require:
      - file: /etc/nginx/sites-available/dotclockproductions.com

{% if enable_ssl %}
dotclockproductions-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --agree-tos --email scott+letsencrypt@smitelli.com
        --non-interactive --standalone --must-staple
        --domains dotclockproductions.com,www.dotclockproductions.com
    - runas: root
    - creates: /etc/letsencrypt/live/dotclockproductions.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
