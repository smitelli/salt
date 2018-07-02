laurenedman-com:
  group.present:
    - gid: 1109

  user.present:
    - uid: 1109
    - gid_from_name: True
    - fullname: laurenedman.com
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: laurenedman-com
