include:
  - awstats.nginx
  - git
  - letsencrypt
  - nginx
  - opt.website
  - user.deploy

# Necessary for "require: sls: website"
# See https://github.com/saltstack/salt/issues/10852
website-require-dummy:
  test.nop:
    - require:
      #- sls: awstats.nginx
      - sls: git
      #- sls: letsencrypt
      # Be careful; requiring the nginx service invokes recursion (due to the
      # watches on sites-available and sites-enabled) and it's not clear why.
      #- pkg: nginx
      #- sls: opt.website
      #- sls: user.deploy
