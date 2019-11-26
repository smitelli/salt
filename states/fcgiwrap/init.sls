fcgiwrap:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: fcgiwrap
