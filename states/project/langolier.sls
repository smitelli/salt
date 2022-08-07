include:
  - project
  - cron
  - python3.pip
  - python3.virtualenv
  - user.langolier

langolier-repo:
  git.latest:
    - name: https://github.com/smitelli/langolier.git
    - branch: master
    - rev: HEAD
    - submodules: True
    - target: /opt/project/langolier
    - user: deploy
    - require:
      - sls: project

/opt/project/langolier/smitelli.yml:
  file.managed:
    - source: salt://project/files/langolier/smitelli.yml
    - template: jinja
    - user: langolier
    - group: langolier
    - mode: 400
    - show_changes: False
    - require:
      - git: langolier-repo
      - user: langolier

/opt/project/langolier/engrishsmitelli.yml:
  file.managed:
    - source: salt://project/files/langolier/engrishsmitelli.yml
    - template: jinja
    - user: langolier
    - group: langolier
    - mode: 400
    - show_changes: False
    - require:
      - git: langolier-repo
      - user: langolier

/var/opt/project/langolier:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - require:
      - sls: project

/var/opt/project/langolier/.virtualenv:
  file.directory:
    - user: deploy
    - group: deploy
    - mode: 755
    - require:
      - file: /var/opt/project/langolier
  virtualenv.managed:
    - python: /usr/bin/python3
    - pip_upgrade: True
    - user: deploy
    - require:
      - file: /var/opt/project/langolier/.virtualenv
      - pkg: python3-pip
      - pkg: python3-virtualenv
  pip.installed:
    - bin_env: /var/opt/project/langolier/.virtualenv
    - editable: /opt/project/langolier
    - upgrade: True
    - user: deploy
    - require:
      - virtualenv: /var/opt/project/langolier/.virtualenv
    - onchanges:
      - git: langolier-repo

/var/log/project/langolier:
  file.directory:
    - user: langolier
    - group: langolier
    - mode: 755
    - require:
      - user: langolier

/etc/cron.d/langolier:
  file.managed:
    - source: salt://project/files/langolier/cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - user: langolier
    - watch_in:
      - service: cron

/etc/logrotate.d/langolier:
  file.managed:
    - source: salt://project/files/langolier/logrotate
    - user: root
    - group: root
    - mode: 644
