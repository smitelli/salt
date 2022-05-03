rsync:
  pkg.latest

# This should be installed by the package, but in Debian 10 (at least) it isn't!
{% for f in ('/bin/rrsync', '/usr/bin/rrsync') %}
{{ f | yaml_encode }}:
  file.managed:
    - source: /usr/share/rsync/scripts/rrsync
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: rsync
{% endfor %}
