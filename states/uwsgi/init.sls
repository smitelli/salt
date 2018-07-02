uwsgi:
  pkg.latest:
    - aggregate: True
  service.running:
    - enable: True
    - watch:
      - pkg: uwsgi
      - file: /etc/uwsgi/apps-available/*
      - file: /etc/uwsgi/apps-enabled/*

# Ensure apps-available/* watcher works even if nothing puts files there
/etc/uwsgi/apps-available/.:
  file.exists:
    - require:
      - pkg: uwsgi

# Ensure apps-enabled/* watcher works even if nothing puts files there
/etc/uwsgi/apps-enabled/.:
  file.exists:
    - require:
      - pkg: uwsgi
