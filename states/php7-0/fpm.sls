# NOTE: The php7.0-fpm service will not start unless some other state writes
# a pool configuration into pool.d. As written, this SLS will fail to start.

php7.0-fpm:
  pkg.latest:
    - aggregate: True
  service.running:
    - enable: True
    - watch:
      - pkg: php7.0-fpm
      - file: /etc/php/7.0/fpm/conf.d/*
      - file: /etc/php/7.0/fpm/pool.d/*

/etc/php/7.0/fpm/conf.d/99-cgi-security.ini:
  file.managed:
    - source: salt://php7-0/files/cgi-security.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php7.0-fpm

/etc/php/7.0/fpm/pool.d/www.conf:
  file.absent:
    - require:
      - pkg: php7.0-fpm
