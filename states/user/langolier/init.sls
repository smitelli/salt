langolier:
  group.present:
    - gid: 1111

  user.present:
    - uid: 1111
    - gid: langolier
    - fullname: Langolier
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: langolier
