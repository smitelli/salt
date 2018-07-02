include:
  - acl
  - user.deploy

/opt/website:
  file.directory:
    - user: root
    - group: root
    - mode: 775  # Needs group writable for the ACL to work correctly
  acl.present:
    - acl_type: group
    - acl_name: deploy
    - perms: rwx
    - require:
      - pkg: acl
      - group: deploy

/var/log/website:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/var/opt/website:
  file.directory:
    - user: root
    - group: root
    - mode: 755
