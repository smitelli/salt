twitstash:
  group.present:
    - gid: 1107

  user.present:
    - uid: 1107
    - gid: twitstash
    - fullname: Twitstash
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: twitstash
