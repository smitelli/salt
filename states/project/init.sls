include:
  - git
  - opt.project
  - user.deploy

# Necessary for "require: sls: project"
# See https://github.com/saltstack/salt/issues/10852
project-require-dummy:
  test.nop:
    - require:
      - sls: git
      - sls: opt.project
      - sls: user.deploy
