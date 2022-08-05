windowbox:
  group.present:
    - gid: 1105

  user.present:
    - uid: 1105
    - gid: windowbox
    - fullname: Windowbox
    - home: /nonexistent
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: windowbox
