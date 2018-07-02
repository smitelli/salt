# NOTE: This SLS is not indended to be used directly. It should be `include`d
# from any of the accompanying SLS files in this directory.

include:
  - etc.aliases
  - etc.mailname

exim4:
  service.running:
    - enable: True
    - watch:
      - file: /etc/exim4/*
      - file: /etc/aliases
      - file: /etc/mailname

/etc/exim4:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/exim4/domains.virtual:
  file.managed:
    - replace: False
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/exim4

domains.virtual-base:
  file.append:
    - name: /etc/exim4/domains.virtual
    - text: {{ grains['fqdn'] | yaml_encode }}

/etc/exim4/update-exim4.conf.conf:
  file.managed:
    - source: salt://exim4/files/update-exim4.conf.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/exim4
