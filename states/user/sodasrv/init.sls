sodasrv:
  group.present:
    - gid: 1108

  user.present:
    - uid: 1108
    - gid: sodasrv
    - fullname: Sodasrv
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: sodasrv
