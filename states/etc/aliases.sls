/etc/aliases:
  file.replace:
    - pattern: ^root:\s+.+$
    - repl: "root: {{ salt['pillar.get']('etc:aliases:root') }}"
    - append_if_not_found: True
    - backup: False
