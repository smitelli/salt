{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:northernflickermusic-com:enable_ssl', False)
) %}

include:
  - website

/var/opt/website/northernflickermusic.com:
  file.directory:
    - user: deploy
    - group: deploy
    - mode: 755
    - require:
      - sls: website

/var/opt/website/northernflickermusic.com/public:
  file.directory:
    - user: ledman
    - group: ledman
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - group
      - mode
    - require:
      - file: /var/opt/website/northernflickermusic.com
      - user: ledman

/etc/awstats/awstats.northernflickermusic.com.conf:
  file.managed:
    - source: salt://website/files/northernflickermusic.com/awstats.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats

/etc/nginx/sites-available/northernflickermusic.com:
  file.managed:
    - source: salt://website/files/northernflickermusic.com/nginx.conf
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
      - file: /var/opt/website/northernflickermusic.com
      - pkg: nginx

/etc/nginx/sites-enabled/northernflickermusic.com:
  file.symlink:
    - target: /etc/nginx/sites-available/northernflickermusic.com
    - require:
      - file: /etc/nginx/sites-available/northernflickermusic.com

{% if enable_ssl %}
northernflickermusic-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains northernflickermusic.com,www.northernflickermusic.com
    - runas: root
    - creates: /etc/letsencrypt/live/northernflickermusic.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
