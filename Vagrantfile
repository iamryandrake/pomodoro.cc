Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.hostname = 'pomodoro.dev'
  config.ssh.shell = 'bash -c \'BASH_ENV=/etc/profile exec bash\''

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--cpus", 2]
  end

  config.vm.hostname = "pomodoro.dev"
  config.vm.network :private_network, ip: "192.168.11.2"
  config.vm.network "forwarded_port", guest: 80, host: 8081

  config.vm.synced_folder "./", "/vagrant", type: "nfs"

  config.vm.provision "docker" do |d|
    d.pull_images "redis"
    d.pull_images "mongo"
  end

  config.vm.provision "shell", run: "always", path: "opt/docker.dev.sh"

end
