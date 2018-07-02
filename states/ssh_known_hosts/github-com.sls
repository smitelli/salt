include:
  - user.deploy

github.com:
  ssh_known_hosts.present:
    - user: deploy
    - enc: ssh-rsa
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
    - fingerprint_hash_type: md5
    - require:
      - user: deploy
