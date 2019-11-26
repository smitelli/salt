include:
  - project
  - cron
  - php.cli
  - php.curl
  - php.mbstring
  - user.sort_of_face

sort_of_face-repo:
  git.latest:
    - name: https://github.com/smitelli/sort_of_face.git
    - branch: master
    - rev: HEAD
    - submodules: True
    - target: /opt/project/sort_of_face
    - user: deploy
    - require:
      - sls: project

/opt/project/sort_of_face/config.ini:
  file.managed:
    - source: salt://project/files/sort_of_face/config.ini
    - template: jinja
    - user: sort_of_face
    - group: sort_of_face
    - mode: 400
    - show_changes: False
    - require:
      - git: sort_of_face-repo
      - user: sort_of_face

/var/log/project/sort_of_face:
  file.directory:
    - user: sort_of_face
    - group: sort_of_face
    - mode: 755
    - require:
      - user: sort_of_face

/etc/cron.d/sort_of_face:
  file.managed:
    - source: salt://project/files/sort_of_face/cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: cron
      - user: sort_of_face
    - watch_in:
      - service: cron

/etc/logrotate.d/sort_of_face:
  file.managed:
    - source: salt://project/files/sort_of_face/logrotate
    - user: root
    - group: root
    - mode: 644
