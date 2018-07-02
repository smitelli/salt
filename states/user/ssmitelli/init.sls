{% set authorized_keys = salt['pillar.get']('user:ssmitelli:public:authorized_keys', []) %}

ssmitelli:
  group.present:
    - gid: 1500

  user.present:
    - uid: 1500
    - gid_from_name: True
    - groups:
        - sudo
    - password: {{ salt['pillar.get']('user:ssmitelli:private:password') | yaml_encode }}
    - fullname: Scott Smitelli
    - shell: /bin/bash
    - require:
      - group: ssmitelli

{% for key in authorized_keys %}
{{ key['key'] | yaml_encode }}:
  ssh_auth.present:
    - user: ssmitelli
    - enc: {{ key['enc'] | yaml_encode }}
    - comment: {{ key['comment'] | yaml_encode }}
    - require:
      - user: ssmitelli
{% endfor %}
