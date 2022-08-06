{% set version = salt['pillar.get']('mysqltuner:version') %}
{% set hash = salt['pillar.get']('mysqltuner:hash') %}

mysqltuner-source:
  archive.extracted:
    - name: /usr/local/src
    - source: https://github.com/major/MySQLTuner-perl/archive/v{{ version }}.tar.gz
    - source_hash: {{ hash | yaml_encode }}
    - clean: True
    - user: root
    - group: root

/usr/sbin/mysqltuner:
  file.symlink:
    - target: /usr/local/src/MySQLTuner-perl-{{ version }}/mysqltuner.pl
    - require:
      - archive: mysqltuner-source
