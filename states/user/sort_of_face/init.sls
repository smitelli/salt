sort_of_face:
  group.present:
    - gid: 1106

  user.present:
    - uid: 1106
    - gid_from_name: True
    - fullname: The sort of face
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: sort_of_face
