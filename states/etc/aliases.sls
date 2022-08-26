/etc/aliases:
  file.replace:
    - pattern: ^root:\s+.+$
    - repl: "root: {{ salt['pillar.get']('etc:aliases:root') }}"
    - append_if_not_found: True
    - backup: False
    # HACK: https://github.com/saltstack/salt/issues/57584#issuecomment-984846776
    - bufsize: file
