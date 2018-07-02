internetstapler-com:
  group.present:
    - gid: 1101

  user.present:
    - uid: 1101
    - gid_from_name: True
    - fullname: internetstapler.com
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: internetstapler-com
