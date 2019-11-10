nftables:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: nftables
      - file: /etc/nftables.conf

iptables:
  pkg.purged:
    - pkgs:
      - iptables
      - iptables-persistent
      - netfilter-persistent

/etc/nftables.conf:
  file.managed:
    - source: salt://nftables/files/nftables.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nftables
