include:
  - icinga2.ido-mysql
  - icinga2.icingaweb2
  - icinga2.monitoring-plugins

icinga2:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: icinga2
      - file: /etc/icinga2/features-available/*
      - file: /etc/icinga2/features-enabled/*
