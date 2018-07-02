windowbox:
  group.present:
    - gid: 1105

  user.present:
    - uid: 1105
    - gid_from_name: True
    - fullname: Windowbox
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: windowbox
