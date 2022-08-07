{% set enable_exim_jail = salt['pillar.get']('fail2ban:enable_exim_jail', False) %}
{% set enable_sshd_jail = salt['pillar.get']('fail2ban:enable_sshd_jail', False) %}

include:
  - nftables

fail2ban:
  pkg:
    - latest
  service.running:
    - enable: True
    - watch:
      - pkg: fail2ban
    - require:
      - pkg: nftables

/etc/fail2ban/jail.d/defaults-debian.conf:
  file.absent:
    - require:
      - pkg: fail2ban

/etc/fail2ban/jail.d/default.conf:
  file.managed:
    - source: salt://fail2ban/files/default.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: fail2ban
    - watch_in:
      - service: fail2ban

/etc/fail2ban/jail.d/exim.conf:
{% if enable_exim_jail %}
  file.managed:
    - source: salt://fail2ban/files/exim.conf
    - user: root
    - group: root
    - mode: 644
{% else %}
  file.absent:
{% endif %}
    - require:
      - pkg: fail2ban
    - watch_in:
      - service: fail2ban

/etc/fail2ban/jail.d/sshd.conf:
{% if enable_sshd_jail %}
  file.managed:
    - source: salt://fail2ban/files/sshd.conf
    - user: root
    - group: root
    - mode: 644
{% else %}
  file.absent:
{% endif %}
    - require:
      - pkg: fail2ban
    - watch_in:
      - service: fail2ban
