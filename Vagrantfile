Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-buster64"
  config.vm.post_up_message = nil

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 1
    vb.memory = 1024
  end

  config.vm.hostname = "dev-salt"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.synced_folder ".", "/srv/salt", mount_options: ["dmode=555", "fmode=444"]

  config.vm.provision "shell", privileged: true, inline: <<~EOF
    mkdir -p /etc/salt/gpgkeys
    cp /srv/salt/.gpgkeys/*.gpg /etc/salt/gpgkeys/
  EOF

  # Salt 2019.2.1 needs at least pip 18.1 (python2 version) installed.
  # See https://github.com/saltstack/salt/issues/54773
  config.vm.provision "shell", privileged: true, inline: <<~EOF
    apt-get -y update
    apt-get -y install python-pip
  EOF

  config.vm.provision "salt" do |salt|
    salt.masterless = true
    salt.run_highstate = true
    salt.bootstrap_options = "-X"
    salt.minion_config = "./states/salt/files/minion.conf"

    salt.colorize = true
    salt.verbose = true
    salt.log_level = "info"
  end
end
