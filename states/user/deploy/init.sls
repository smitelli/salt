deploy:
  group.present:
    - gid: 1100

  user.present:
    - uid: 1100
    - gid: deploy
    - fullname: Deploy User
    - shell: /usr/sbin/nologin
    - require:
      - group: deploy
