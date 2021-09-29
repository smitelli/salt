{% set enable_ssl = (
  salt['pillar.get']('nginx:enable_ssl', False) and
  salt['pillar.get']('website:laurenedman-com:enable_ssl', False)
) %}

include:
  - website

/etc/nginx/sites-available/laurenedman.com:
  file.managed:
    - source: salt://website/files/laurenedman.com/nginx.conf
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
      - pkg: nginx

/etc/nginx/sites-enabled/laurenedman.com:
  file.symlink:
    - target: /etc/nginx/sites-available/laurenedman.com
    - require:
      - file: /etc/nginx/sites-available/laurenedman.com

{% if enable_ssl %}
laurenedman-com-letsencrypt:
  cmd.run:
    - name: >
        /usr/sbin/service nginx stop;
        /usr/local/bin/certbot certonly --standalone --domains laurenedman.com,www.laurenedman.com
    - runas: root
    - creates: /etc/letsencrypt/live/laurenedman.com/fullchain.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /usr/local/bin/certbot
{% endif %}
