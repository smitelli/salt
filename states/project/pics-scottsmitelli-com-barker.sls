# NOTE: The script /opt/project/pics.scottsmitelli.com-barker/cron.sh should be
# run by cron, which is not done here. (Instead it is done in
# website.pics-scottsmitelli-com's cron, to ensure the barker script runs after
# the fetch script returns.)

include:
  - project
  - python.pip
  - python.virtualenv
  - user.windowbox

pics-scottsmitelli-com-barker-repo:
  git.latest:
    - name: https://github.com/smitelli/windowbox-barker.git
    - branch: master
    - rev: HEAD
    - target: /opt/project/pics.scottsmitelli.com-barker
    - user: deploy
    - require:
      - sls: project

/opt/project/pics.scottsmitelli.com-barker/build.sh:
  cmd.wait:
    - runas: deploy
    - watch:
      - git: pics-scottsmitelli-com-barker-repo

/opt/project/pics.scottsmitelli.com-barker/config.ini:
  file.managed:
    - source: salt://project/files/pics.scottsmitelli.com-barker/config.ini
    - template: jinja
    - user: windowbox
    - group: windowbox
    - mode: 400
    - show_changes: False
    - require:
      - git: pics-scottsmitelli-com-barker-repo
      - user: windowbox

/var/log/project/pics.scottsmitelli.com-barker:
  file.directory:
    - user: windowbox
    - group: windowbox
    - mode: 755
    - require:
      - user: windowbox

/var/opt/project/pics.scottsmitelli.com-barker:
  file.directory:
    - user: windowbox
    - group: windowbox
    - mode: 755
    - require:
      - sls: project
      - user: windowbox

/etc/logrotate.d/pics.scottsmitelli.com-barker:
  file.managed:
    - source: salt://project/files/pics.scottsmitelli.com-barker/logrotate
    - user: root
    - group: root
    - mode: 644
