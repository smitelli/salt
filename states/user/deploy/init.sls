deploy:
  group.present:
    - gid: 1100

  user.present:
    - uid: 1100
    - gid_from_name: True
    - fullname: Deploy User
    - shell: /bin/false
    - require:
      - group: deploy
