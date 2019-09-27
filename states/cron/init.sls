cron:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: cron
      - file: /etc/cron.d/*

# Ensure cron.d/* watcher works even if nothing puts files there
/etc/cron.d/.:
  file.exists:
    - require:
      - pkg: cron
