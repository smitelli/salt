git:
  pkg.latest

# HACK: Silence irritating runtime errors from Salt 2019.02.1
/root/.gitconfig:
  file.managed:
    - contents:
      - '[filter "lfs"]'
      - 'dummy = dummy'
    - user: root
    - group: root
    - mode: 644
    - require_in:
      - pkg: git
