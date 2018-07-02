{% set version = salt['pillar.get']('fail2ban:version') %}
{% set hash = salt['pillar.get']('fail2ban:hash') %}
{% set enable_exim_jail = salt['pillar.get']('fail2ban:enable_exim_jail', False) %}
{% set enable_sshd_jail = salt['pillar.get']('fail2ban:enable_sshd_jail', False) %}

include:
  - iptables
  - python3.pyinotify
  - python3.systemd

fail2ban:
  service.running:
    - enable: True
    - watch:
      - cmd: fail2ban-install
      - file: /etc/fail2ban/filter.d/*
      - file: /etc/fail2ban/jail.d/*
    - require:
      - file: /lib/systemd/system/fail2ban.service
      - pkg: iptables

fail2ban-source:
  archive.extracted:
    - name: /usr/local/src
    - source: https://github.com/fail2ban/fail2ban/archive/{{ version }}.tar.gz
    - source_hash: {{ hash | yaml_encode }}
    - clean: True
    - user: root
    - group: root

fail2ban-install:
  cmd.wait:
    - name: /usr/bin/python3 setup.py install --force
    - cwd: /usr/local/src/fail2ban-{{ version }}
    - runas: root
    - watch:
      - archive: fail2ban-source
    - require:
      - pkg: python3-pyinotify
      - pkg: python3-systemd

/etc/bash_completion.d/fail2ban:
  file.managed:
    - source: /usr/local/src/fail2ban-{{ version }}/files/bash-completion
    - user: root
    - group: root
    - mode: 644
    - watch:
      - cmd: fail2ban-install

/usr/lib/tmpfiles.d/fail2ban.conf:
  file.managed:
    - source: /usr/local/src/fail2ban-{{ version }}/files/fail2ban-tmpfiles.conf
    - user: root
    - group: root
    - mode: 644
    - watch:
      - cmd: fail2ban-install

/lib/systemd/system/fail2ban.service:
  file.managed:
    - source: /usr/local/src/fail2ban-{{ version }}/build/fail2ban.service
    - user: root
    - group: root
    - mode: 644
    - watch:
      - cmd: fail2ban-install

# Ensure filter.d/* watcher works even if nothing puts files there
/etc/fail2ban/filter.d/.:
  file.exists:
    - require:
      - cmd: fail2ban-install

# Ensure jail.d/* watcher works even if nothing puts files there
/etc/fail2ban/jail.d/.:
  file.exists:
    - require:
      - cmd: fail2ban-install

/etc/logrotate.d/fail2ban:
  file.managed:
    - source: salt://fail2ban/files/logrotate
    - user: root
    - group: root
    - mode: 644

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
      - cmd: fail2ban-install

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
      - cmd: fail2ban-install
