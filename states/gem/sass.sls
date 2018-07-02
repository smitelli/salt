include:
  - build-essential
  - ruby
  - ruby.dev

sass:
  gem.installed:
    - require:
      - pkg: build-essential
      - pkg: ruby
      - pkg: ruby-dev
