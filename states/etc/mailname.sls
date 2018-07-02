/etc/mailname:
  file.managed:
    - contents_grains: fqdn
    - user: root
    - group: root
    - mode: 644
