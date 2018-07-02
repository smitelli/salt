include:
  - exim4

exim4-daemon-light:
  pkg.latest:
    - aggregate: True
    - require_in:
      - file: /etc/exim4
      - service: exim4
    - watch_in:
      - service: exim4
