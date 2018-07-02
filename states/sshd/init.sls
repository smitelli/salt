{% set password_authentication = salt['pillar.get']('sshd:password_authentication', '') %}
{% set permit_root_login = salt['pillar.get']('sshd:permit_root_login', '') %}

openssh-server:
  pkg.latest:
    - aggregate: True
  service.running:
    - name: ssh
    - enable: True
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/*

{% if password_authentication %}
sshd_config-PasswordAuthentication:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[#\s]*PasswordAuthentication\s+.+$
    - repl: PasswordAuthentication {{ password_authentication }}
    - append_if_not_found: True
    - backup: False
    - require:
      - pkg: openssh-server
{% endif %}

{% if permit_root_login %}
sshd_config-PermitRootLogin:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[#\s]*PermitRootLogin\s+.+$
    - repl: PermitRootLogin {{ permit_root_login }}
    - append_if_not_found: True
    - backup: False
    - require:
      - pkg: openssh-server
{% endif %}

{% for ktype in ('dsa', 'ecdsa', 'ed25519', 'rsa'): %}
/etc/ssh/ssh_host_{{ ktype }}_key:
  file.managed:
    - contents_pillar: {{ ('sshd:' ~ grains['id'] ~ ':private:ssh_' ~ ktype ~ '_key') | yaml_encode }}
    - user: root
    - group: root
    - mode: 600
    - show_changes: False
    - require:
      - pkg: openssh-server

/etc/ssh/ssh_host_{{ ktype }}_key.pub:
  file.managed:
    - contents_pillar: {{ ('sshd:' ~ grains['id'] ~ ':public:ssh_' ~ ktype ~ '_key') | yaml_encode }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openssh-server
{% endfor %}
