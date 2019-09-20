{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:internetstapler-com:enable_ssl', False)
) %}

include:
  - website
  - php7-0.fpm
  - user.internetstapler-com

internetstapler-com-repo:
  git.latest:
    - name: https://github.com/smitelli/internetstapler.com.git
    - branch: master
    - rev: HEAD
    - target: /opt/website/internetstapler.com
    - user: deploy
    - require:
      - sls: website

/etc/awstats/awstats.internetstapler.com.conf:
  file.managed:
    - source: salt://website/files/internetstapler.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/internetstapler.com:
  file.managed:
    - source: salt://website/files/internetstapler.com/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      enable_ssl: {{ enable_ssl | yaml_encode }}
      expect_ct_max_age: {{ 7 * 24 * 60 * 60 }}
    - require:
{% if enable_ssl %}
      - file: /etc/nginx/conf.d/ssl.conf
{% endif %}
      - git: internetstapler-com-repo
      - pkg: nginx

/etc/nginx/sites-enabled/internetstapler.com:
  file.symlink:
    - target: /etc/nginx/sites-available/internetstapler.com
    - require:
      - file: /etc/nginx/sites-available/internetstapler.com

/etc/php/7.0/fpm/pool.d/internetstapler.com.conf:
  file.managed:
    - source: salt://website/files/internetstapler.com/fpm.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php7.0-fpm
      - git: internetstapler-com-repo
      - user: internetstapler-com

{% if enable_ssl %}
internetstapler-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains internetstapler.com,www.internetstapler.com
    - runas: root
    - creates: /etc/letsencrypt/live/internetstapler.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
