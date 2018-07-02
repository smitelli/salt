# NOTE: The script /opt/project/twanslationparty-engrishsmitelli/cron.sh should
# be run by cron, which is not done here. (Instead it is done in
# project.twitstash-smitelli's cron, to ensure the twanslation script runs after
# the stash script returns.)

include:
  - project
  - php7-0.cli
  - php7-0.curl
  - php7-0.mbstring
  - php7-0.mysql
  - php7-0.xml
  - user.twitstash

twanslationparty-engrishsmitelli-repo:
  git.latest:
    - name: https://github.com/smitelli/twanslationparty.git
    - branch: master
    - rev: HEAD
    - submodules: True
    - target: /opt/project/twanslationparty-engrishsmitelli
    - user: deploy
    - require:
      - sls: project

/opt/project/twanslationparty-engrishsmitelli/config.ini:
  file.managed:
    - source: salt://project/files/twanslationparty-engrishsmitelli/config.ini
    - template: jinja
    - user: twitstash
    - group: twitstash
    - mode: 400
    - show_changes: False
    - require:
      - git: twanslationparty-engrishsmitelli-repo
      - user: twitstash

/var/log/project/twanslationparty-engrishsmitelli:
  file.directory:
    - user: twitstash
    - group: twitstash
    - mode: 755
    - require:
      - user: twitstash

/etc/logrotate.d/twanslationparty-engrishsmitelli:
  file.managed:
    - source: salt://project/files/twanslationparty-engrishsmitelli/logrotate
    - user: root
    - group: root
    - mode: 644
