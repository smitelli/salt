internetstapler-com:
  group.present:
    - gid: 1101

  user.present:
    - uid: 1101
    - gid: internetstapler-com
    - fullname: internetstapler.com
    - home: /nonexistent
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: internetstapler-com
