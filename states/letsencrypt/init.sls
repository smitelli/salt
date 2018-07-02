include:
  - cron
  - python.virtualenv
  - python3.pip

/opt/letsencrypt:
  virtualenv.managed:
    - python: /usr/bin/python3
    - pip_pkgs:
      - certbot
      - pip
    - pip_upgrade: True
    - require:
      - pkg: python-virtualenv
      - pkg: python3-pip

/usr/local/bin/certbot:
  file.symlink:
    - target: /opt/letsencrypt/bin/certbot
    - require:
      - virtualenv: /opt/letsencrypt

# This cron job takes the rather opinionated stance that the web server is
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
