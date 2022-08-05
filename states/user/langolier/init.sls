langolier:
  group.present:
    - gid: 1111

  user.present:
    - uid: 1111
    - gid: langolier
    - fullname: Langolier
    - home: /nonexistent
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: langolier
