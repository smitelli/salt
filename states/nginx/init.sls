{% set enable_ssl = salt['pillar.get']('nginx:enable_ssl', False) %}

nginx:
  pkg.latest:
    - name: nginx-full
  service.running:
    - enable: True
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/*
      - file: /etc/nginx/sites-available/*
      - file: /etc/nginx/sites-enabled/*
      - file: /etc/nginx/snippets/*

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/files/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
      expect_ct_max_age: {{ 7 * 24 * 60 * 60 }}
      strict_transport_security_max_age: {{ 2 * 365 * 24 * 60 * 60 }}
    - require:
      - pkg: nginx

{% for f in ('charset.conf', 'gzip.conf', 'open-file-cache.conf') %}
/etc/nginx/conf.d/{{ f }}:
  file.managed:
    - source: salt://nginx/files/{{ f }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx
{% endfor %}

{% for f in ('security-headers.conf', ) %}
/etc/nginx/snippets/{{ f }}:
  file.managed:
    - source: salt://nginx/files/{{ f }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx
{% endfor %}

nginx-logrotate-file-mode:
  file.line:
    - name: /etc/logrotate.d/nginx
    - match: create 0640 www-data adm
    - content: create 0644 www-data adm
    - mode: replace
    - indent: True
    - require:
      - pkg: nginx

{% if enable_ssl %}
dhparam-pem:
  cmd.run:
    # NOTE: The longest this seems to take on a 4 GB Linode is about 15 minutes
    - name: /usr/bin/openssl dhparam -out /etc/ssl/dhparam.pem 4096
    - creates: /etc/ssl/dhparam.pem
    - runas: root

/etc/nginx/conf.d/ssl.conf:
  file.managed:
    - source: salt://nginx/files/ssl.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: dhparam-pem
      - pkg: nginx
{% endif %}

/etc/nginx/sites-available/default:
  file.absent:
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/default:
  file.absent:
    - require:
      - pkg: nginx

/var/www/html:
  file.absent:
    - require:
      - pkg: nginx
