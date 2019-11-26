{% set authorized_keys = salt['pillar.get']('user:ssmitelli:public:authorized_keys', []) %}
{% set stow_packages = salt['pillar.get']('user:ssmitelli:stow_packages', False) %}

include:
  - git
  - stow

ssmitelli:
  group.present:
    - gid: 1500

  user.present:
    - uid: 1500
    - gid_from_name: True
    - groups:
        - sudo
    - password: {{ salt['pillar.get']('user:ssmitelli:private:password', '!') | yaml_encode }}
    - fullname: Scott Smitelli
    - home: /home/ssmitelli
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

scottfiles-repo:
  git.latest:
    - name: https://github.com/smitelli/scottfiles.git
    - branch: master
    - rev: HEAD
    - target: /home/ssmitelli/.scottfiles
    - user: ssmitelli
    - require:
      - sls: git
      - user: ssmitelli

{% if stow_packages %}
scottfiles-stow:
  cmd.run:
    - name: >
        {% if 'bash' in stow_packages -%}
        rm ../{.bash_logout,.bashrc};
        {%- endif %}
        stow -R {{ stow_packages }}
    - cwd: /home/ssmitelli/.scottfiles
    - runas: ssmitelli
    - onchanges:
      - git: scottfiles-repo
{% endif %}
