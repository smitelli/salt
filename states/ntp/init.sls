ntp:
  pkg.latest:
    - aggregate: True
  service.running:
    - enable: True
    - watch:
      - pkg: ntp
