# NOTE: The php-fpm service will not start unless some other state writes
# a pool configuration into pool.d. In isolation, this SLS will fail to start.

{% set php_version = '7.3' %}

php-fpm:
  pkg:
    - latest
  service.running:
    - name: php{{ php_version }}-fpm
    - enable: True
    - watch:
      - pkg: php-fpm
      - file: /etc/php/{{ php_version }}/fpm/conf.d/*
      - file: /etc/php/{{ php_version }}/fpm/pool.d/*
      - file: /etc/php/current/fpm/pool.d/*

/etc/php/{{ php_version }}/fpm/conf.d/99-cgi-security.ini:
  file.managed:
    - source: salt://php/files/cgi-security.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: php-fpm

/etc/php/{{ php_version }}/fpm/pool.d/www.conf:
  file.absent:
    - require:
      - pkg: php-fpm

# Install symlink so we don't have to plaster the PHP version everywhere
/etc/php/current:
  file.symlink:
    - target: /etc/php/{{ php_version }}
    - require:
      - pkg: php-fpm
