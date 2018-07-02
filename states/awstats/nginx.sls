include:
  - awstats
  - fcgiwrap
  - nginx

/etc/nginx/snippets/awstats.conf:
  file.managed:
    - source: salt://awstats/files/nginx-snippet.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: awstats
      - pkg: fcgiwrap
      - pkg: nginx
