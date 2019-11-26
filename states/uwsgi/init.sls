uwsgi:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: uwsgi
