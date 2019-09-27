iptables:
  pkg.latest

iptables-persistent:
  pkg.latest

netfilter-persistent:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: iptables
      - pkg: iptables-persistent
      - pkg: netfilter-persistent
      - file: /etc/iptables/*

# IMHO this is a damn sight easier than salt.states.iptables
{% for version in ('v4', 'v6') -%}
  /etc/iptables/rules.{{ version }}:
    file.managed:
      - source: salt://iptables/files/rules.{{ version }}
      - template: jinja
      - user: root
      - group: root
      - mode: 644
      - context:
        allow_http: {{ salt['pillar.get']('iptables:' ~ version ~ ':allow_http', False) | yaml_encode }}
        allow_https: {{ salt['pillar.get']('iptables:' ~ version ~ ':allow_https', False) | yaml_encode }}
        # NOTE: Ping (and all inbound ICMP) is unconditionally allowed in v6
        allow_ping: {{ salt['pillar.get']('iptables:' ~ version ~ ':allow_ping', False) | yaml_encode }}
        allow_smtp: {{ salt['pillar.get']('iptables:' ~ version ~ ':allow_smtp', False) | yaml_encode }}
        # Allow SSH by default if pillar doesn't specify, to avoid lockout
        allow_ssh: {{ salt['pillar.get']('iptables:' ~ version ~ ':allow_ssh', True) | yaml_encode }}
      - require:
        - pkg: iptables-persistent
{% endfor %}
