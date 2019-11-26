cron:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: cron
