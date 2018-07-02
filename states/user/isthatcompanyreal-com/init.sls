isthatcompanyreal-com:
  group.present:
    - gid: 1102

  user.present:
    - uid: 1102
    - gid_from_name: True
    - fullname: isthatcompanyreal.com
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: isthatcompanyreal-com
