scottsmitelli-com:
  group.present:
    - gid: 1103

  user.present:
    - uid: 1103
    - gid_from_name: True
    - fullname: scottsmitelli.com
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: scottsmitelli-com
