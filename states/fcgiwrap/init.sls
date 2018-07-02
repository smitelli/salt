fcgiwrap:
  pkg.latest:
    - aggregate: True
  service.running:
    - enable: True
    - watch:
      - pkg: fcgiwrap
