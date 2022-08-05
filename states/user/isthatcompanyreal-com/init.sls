isthatcompanyreal-com:
  group.present:
    - gid: 1102

  user.present:
    - uid: 1102
    - gid: isthatcompanyreal-com
    - fullname: isthatcompanyreal.com
    - home: /nonexistent
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: isthatcompanyreal-com
