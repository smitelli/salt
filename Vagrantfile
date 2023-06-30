Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vbox|
    vbox.cpus = 1
    vbox.memory = 1024
  end

  config.vm.box = "debian/bookworm64"
  config.vm.post_up_message = nil

  config.vm.hostname = "dev-salt"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.synced_folder ".", "/srv/salt", mount_options: ["dmode=555", "fmode=444"]

  config.vm.provision "shell", privileged: true, inline: <<~EOF
    mkdir -p /etc/salt/gpgkeys
    cp /srv/salt/.gpgkeys/*.gpg /etc/salt/gpgkeys/

    # TODO 2023-06-29 salt-bootstrap points to a non-existent Debian 12 repo
    # https://github.com/saltstack/salt/issues/64223
    wget -O /etc/apt/keyrings/salt-archive-keyring-2023.gpg https://repo.saltproject.io/salt/py3/debian/11/amd64/SALT-PROJECT-GPG-PUBKEY-2023.gpg
    echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/debian/11/amd64/latest bullseye main" > /etc/apt/sources.list.d/salt.list
    apt-get update
    apt-get install -y build-essential gnupg2 libmariadb-dev pkgconf salt-minion
    cp /srv/salt/states/salt/files/minion.conf /etc/salt/minion.d/00-minion.conf
    salt-pip install mysqlclient
    salt-call --log-level=info --local state.apply
  EOF

  #config.vm.provision "salt" do |salt|
  #  salt.masterless = true
  #  salt.run_highstate = true
  #  salt.bootstrap_options = "-X"
  #  salt.minion_config = "./states/salt/files/minion.conf"
  #
  #  salt.colorize = true
  #  salt.verbose = true
  #  salt.log_level = "info"
  #end
end
