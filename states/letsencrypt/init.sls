include:
  - cron
  - python3.pip
  - python3.virtualenv

/etc/letsencrypt:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/etc/letsencrypt/cli.ini:
  file.managed:
    - source: salt://letsencrypt/files/cli.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/letsencrypt

/opt/letsencrypt:
  virtualenv.managed:
    - python: /usr/bin/python3
    - pip_pkgs:
      - certbot
      - pip
    - pip_upgrade: True
    - require:
      - pkg: python3-pip
      - pkg: virtualenv  # python3 version
      - file: /etc/letsencrypt/cli.ini

/usr/local/bin/certbot:
  file.symlink:
    - target: /opt/letsencrypt/bin/certbot
    - require:
      - virtualenv: /opt/letsencrypt

# NOTE: This cron job takes the rather opinionated stance that the web server is
# nginx, and that it is appropriate to completely stop/restart the service when
# renewal time comes. This may need to change someday.
/etc/cron.d/letsencrypt:
  file.managed:
    - source: salt://letsencrypt/files/cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - file: /usr/local/bin/certbot
    - watch_in:
      - service: cron
