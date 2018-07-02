{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:scottsmitelli-com:enable_ssl', False)
) %}

include:
  - website
  - php7-0.fpm
  - php7-0.tidy
  - user.scottsmitelli-com

scottsmitelli-com-repo:
  git.latest:
    - name: https://github.com/smitelli/scottsmitelli.com.git
    - branch: master
    - rev: HEAD
    - submodules: True
    - target: /opt/website/scottsmitelli.com
    - user: deploy
    - require:
      - sls: website

/var/opt/website/scottsmitelli.com:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - sls: website

/var/opt/website/scottsmitelli.com/compile:
  file.directory:
    - user: scottsmitelli-com
    - group: scottsmitelli-com
    - mode: 755
    - require:
      - file: /var/opt/website/scottsmitelli.com
      - user: scottsmitelli-com

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

/etc/php/7.0/fpm/pool.d/scottsmitelli.com.conf:
  file.managed:
    - source: salt://website/files/scottsmitelli.com/fpm.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php7.0-fpm
      - git: scottsmitelli-com-repo
      - user: scottsmitelli-com

{% if enable_ssl %}
scottsmitelli-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --agree-tos --email scott+letsencrypt@smitelli.com
        --non-interactive --standalone --must-staple
        --domains scottsmitelli.com,www.scottsmitelli.com
    - runas: root
    - creates: /etc/letsencrypt/live/scottsmitelli.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
