langolier:
  group.present:
    - gid: 1109

  user.present:
    - uid: 1109
    - gid: langolier
    - fullname: Langolier
    - home: /nonexistent
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: langolier
