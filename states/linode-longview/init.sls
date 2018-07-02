{% set longview_config = salt['pillar.get']('linode-longview:' ~ grains['id']) %}

include:
  - linode-longview.repo

linode-longview:
  pkg.latest:
    - aggregate: False
    - require:
      - pkgrepo: linode-longview-repo
  service.running:
    - name: longview
    - enable: True
    - watch:
      - pkg: linode-longview
      - file: /etc/linode/*
      - file: /etc/linode/longview.d/*

# Ensure longview.d/* watcher works even if nothing puts files there
/etc/linode/longview.d/.:
  file.exists:
    - require:
      - pkg: linode-longview

/etc/linode/longview.key:
  file.managed:
    - contents: {{ longview_config['api_key'] | yaml_encode }}
    - user: root
    - group: root
    - mode: 600
    - show_changes: False
    - require:
      - pkg: linode-longview

{% if longview_config.get('enable_mysql', False) %}
# This is okay for the Debian socket-based auth; not sure about other distros
/etc/linode/longview.d/MySQL.conf:
  file.managed:
    - contents:
      - 'username root'
      - 'password ""'
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: linode-longview
{% endif %}

{% if longview_config.get('enable_nginx', False) %}
/etc/linode/longview.d/Nginx.conf:
  file.managed:
    - contents: location {{ longview_config['nginx_location'] }}
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: linode-longview
{% endif %}
