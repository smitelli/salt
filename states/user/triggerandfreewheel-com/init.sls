triggerandfreewheel-com:
  group.present:
    - gid: 1104

  user.present:
    - uid: 1104
    - gid: triggerandfreewheel-com
    - fullname: triggerandfreewheel.com
    - home: /nonexistent
    - createhome: False
    - shell: /usr/sbin/nologin
    - require:
      - group: triggerandfreewheel-com
