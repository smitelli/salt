{% set enable_ssh_auth_canyonero = salt['pillar.get']('user:root:enable_ssh_auth_canyonero', False) %}

root:
  group.present:
    - gid: 0

  user.present:
    - uid: 0
    - gid_from_name: True
    - home: /root
    - password: {{ salt['pillar.get']('user:root:password', '!') | yaml_encode }}
    - fullname: root
    - shell: /bin/bash
    - require:
      - group: root

ssh_auth-root@canyonero:
{% if enable_ssh_auth_canyonero %}
  ssh_auth.present:
{% else %}
  ssh_auth.absent:
{% endif %}
    - name: AAAAB3NzaC1yc2EAAAADAQABAAABAQCdWAa7t8YcKOFnxNGkBlOgPkyXqEy7IYJ7lV3qp1iPDHA36HbLCso5jildEg7KOcQsLfToyU44V5Kq46m/eSTGrKNdI0ddDXnG+j9XC8skC/OQBKSEhJucaKbISSR3oCqcaRYgHeH/0pMvHUqlINAgPYqQM+C/PWZDTN/dFEzQaOiDZB105LI4rcNxgZTDZDLm514EOoxPUQBdKFa4JWybEUO6czHtBcyW5L35/Ovut5bb7PtOl9nUk3UunNKlPEQy3MBilr7FZE3KluErckJLstX1840CXDrI6ix1VKb9slJL/ag82KxkXUIsu3XeKK5iq2E6/ASYfd/8mkUgC1uz
    - user: root
    - enc: ssh-rsa
    - comment: root@canyonero
    - options:
      # Disabled due to FreeNAS bug: https://redmine.ixsystems.com/issues/23872
      #- command="rrsync -ro /"
      - restrict
    - require:
      - user: root
