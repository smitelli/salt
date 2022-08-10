include:
  - cron
  - perl.encode
  - perl.net-dns
  - perl.net-ip
  - perl.net-xwhois

awstats:
  pkg.latest

/var/log/awstats:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 755

/etc/awstats/awstats.conf.local:
  file.managed:
    - source: salt://awstats/files/awstats.conf.local
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats
      - pkg: libencode-perl
      - pkg: libnet-dns-perl
      - pkg: libnet-ip-perl
      - pkg: libnet-xwhois-perl

/etc/cron.d/awstats:
  file.managed:
    - source: salt://awstats/files/cron
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /var/log/awstats
      - pkg: awstats
      - pkg: cron
    - watch_in:
      - service: cron

/etc/logrotate.d/awstats:
  file.managed:
    - source: salt://awstats/files/logrotate
    - user: root
    - group: root
    - mode: 644
