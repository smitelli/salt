ntp:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: ntp
