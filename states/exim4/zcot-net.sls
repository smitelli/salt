include:
  - exim4.daemon-light

domains.virtual-zcot.net:
  file.append:
    - name: /etc/exim4/domains.virtual
    - text: zcot.net

/etc/exim4/local_sender_blacklist:
  file.managed:
    - source: salt://exim4/files/zcot.net/local_sender_blacklist
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/exim4

/etc/exim4/zcot.net.deny-local-parts:
  file.managed:
    - source: salt://exim4/files/zcot.net/deny-local-parts
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/exim4

/etc/exim4/conf.d/router/10_zcot_net:
  file.managed:
    - source: salt://exim4/files/zcot.net/router
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/exim4
