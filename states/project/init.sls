include:
  - git
  - opt.project
  - ssh_known_hosts.github-com
  - user.deploy

# Necessary for "require: sls: project"
# See https://github.com/saltstack/salt/issues/10852
project-require-dummy:
  test.nop:
    - require:
      - sls: git
      - sls: opt.project
      - sls: ssh_known_hosts.github-com
      - sls: user.deploy
