Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-stretch64"
  config.vm.post_up_message = nil

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 1
    vb.memory = 1024
  end

  config.vm.hostname = "dev-salt"
  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.synced_folder ".", "/srv/salt", mount_options: ["dmode=555", "fmode=444"]

  config.vm.provision "shell", privileged: false, inline: <<~EOF
    sudo mkdir -p /etc/salt/gpgkeys
    sudo cp /srv/salt/.gpgkeys/*.gpg /etc/salt/gpgkeys/
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
