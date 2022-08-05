ledman:
  group.present:
    - gid: 1501

  user.present:
    - uid: 1501
    - gid: ledman
    - password: {{ salt['pillar.get']('user:ledman:private:password', '!') | yaml_encode }}
    - fullname: Lauren Edman
    - home: /home/ledman
    - shell: /usr/sbin/nologin
    - require:
      - group: ledman

/home/ledman/northernflickermusic-public:
  file.symlink:
    - target: /var/opt/website/northernflickermusic.com/public
