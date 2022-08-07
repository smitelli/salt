{% set password_authentication = salt['pillar.get']('sshd:password_authentication', '') %}
{% set permit_root_login = salt['pillar.get']('sshd:permit_root_login', '') %}

openssh-server:
  pkg:
    - latest
  service.running:
    - name: ssh
    - enable: True
    - watch:
      - pkg: openssh-server

{% if password_authentication %}
sshd_config-PasswordAuthentication:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[#\s]*PasswordAuthentication\s+.+$
    - repl: PasswordAuthentication {{ password_authentication }}
    - append_if_not_found: True
    - backup: False
    # HACK https://github.com/saltstack/salt/issues/57584#issuecomment-984846776
    - bufsize: file
    - require:
      - pkg: openssh-server
    - watch_in:
      - service: ssh
{% endif %}

{% if permit_root_login %}
sshd_config-PermitRootLogin:
  file.replace:
    - name: /etc/ssh/sshd_config
    - pattern: ^[#\s]*PermitRootLogin\s+.+$
    - repl: PermitRootLogin {{ permit_root_login }}
    - append_if_not_found: True
    - backup: False
    # HACK https://github.com/saltstack/salt/issues/57584#issuecomment-984846776
    - bufsize: file
    - require:
      - pkg: openssh-server
    - watch_in:
      - service: ssh
{% endif %}

{% for ktype in ('ecdsa', 'ed25519', 'rsa'): %}
/etc/ssh/ssh_host_{{ ktype }}_key:
  file.managed:
    - contents_pillar: {{ ('sshd:' ~ grains['id'] ~ ':private:ssh_' ~ ktype ~ '_key') | yaml_encode }}
    - user: root
    - group: root
    - mode: 600
    - show_changes: False
    - require:
      - pkg: openssh-server
    - watch_in:
      - service: ssh

/etc/ssh/ssh_host_{{ ktype }}_key.pub:
  file.managed:
    - contents_pillar: {{ ('sshd:' ~ grains['id'] ~ ':public:ssh_' ~ ktype ~ '_key') | yaml_encode }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openssh-server
    - watch_in:
      - service: ssh
{% endfor %}
