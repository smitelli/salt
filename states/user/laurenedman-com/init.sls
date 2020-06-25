laurenedman-com:
  group.present:
    - gid: 1109

  user.present:
    - uid: 1109
    - gid: laurenedman-com
    - fullname: laurenedman.com
    - home: /nonexistent
    - createhome: False
    - shell: /bin/false
    - require:
      - group: laurenedman-com
