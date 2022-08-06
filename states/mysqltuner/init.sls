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
  file.managed:
    - contents: >
      #!/usr/bin/sh
      BASEDIR=/usr/local/src/MySQLTuner-perl-{{ version }}
      $BASEDIR/mysqltuner.pl \
      --passwordfile $BASEDIR/basic_passwords.txt \
      --cvefile $BASEDIR/vulnerabilities.csv \
      "$@"
    - user: root
    - group: root
    - mode: 755
    - require:
      - archive: mysqltuner-source
