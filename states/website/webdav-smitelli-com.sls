{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:webdav-smitelli-com:enable_ssl', False)
) %}

include:
  - website
  - apache2.utils
  - cron
  - fail2ban

/opt/website/webdav.smitelli.com:
  file.directory:
    - user: deploy
    - group: deploy
    - mode: 755
    - require:
      - sls: website

/opt/website/webdav.smitelli.com/.htpasswd:
  file.managed:
    - replace: False
    - user: www-data
    - group: www-data
    - mode: 400
    - require:
      - file: /opt/website/webdav.smitelli.com

/var/opt/website/webdav.smitelli.com:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - sls: website

/var/opt/website/webdav.smitelli.com/git-dir:
  file.directory:
    - user: root
    - group: root
    - mode: 700
    - require:
      - file: /var/opt/website/webdav.smitelli.com

/var/opt/website/webdav.smitelli.com/private:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 700
    - require:
      - file: /var/opt/website/webdav.smitelli.com

/etc/cron.d/webdav-smitelli-com:
  file.managed:
    - source: salt://website/files/webdav.smitelli.com/cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - file: /var/opt/website/webdav.smitelli.com/git-dir
      - file: /var/opt/website/webdav.smitelli.com/private
    - watch_in:
      - service: cron

/etc/fail2ban/jail.d/webdav-smitelli-com.conf:
  file.managed:
    - source: salt://website/files/webdav.smitelli.com/fail2ban-jail.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: fail2ban-install
      - service: nginx
      - file: /etc/nginx/sites-enabled/webdav.smitelli.com

/etc/nginx/sites-available/webdav.smitelli.com:
  file.managed:
    - source: salt://website/files/webdav.smitelli.com/nginx.conf
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
      - file: /var/opt/website/webdav.smitelli.com/private
      - pkg: nginx

/etc/nginx/sites-enabled/webdav.smitelli.com:
  file.symlink:
    - target: /etc/nginx/sites-available/webdav.smitelli.com
    - require:
      - file: /etc/nginx/sites-available/webdav.smitelli.com

webdav-smitelli-com-htpasswd:
  webutil.user_exists:
    - htpasswd_file: /opt/website/webdav.smitelli.com/.htpasswd
    - name: {{ salt['pillar.get']('website:webdav-smitelli-com:htaccess_user') | yaml_encode }}
    - password: {{ salt['pillar.get']('website:webdav-smitelli-com:htaccess_password') | yaml_encode }}
    - options: m
    - update: True
    - require:
      - pkg: apache2-utils
      - file: /opt/website/webdav.smitelli.com/.htpasswd

{% if enable_ssl %}
webdav-smitelli-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains webdav.smitelli.com
    - runas: root
    - creates: /etc/letsencrypt/live/webdav.smitelli.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
