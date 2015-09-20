HOSTNAME = "pomodoro.dev"
Vagrant.configure('2') do |config|
  config.vm.define "web" do |web|
    web.vm.box = "ubuntu/trusty64"
    web.vm.network :private_network, ip: "192.168.11.2"
    web.vm.hostname = HOSTNAME
    web.vm.network "forwarded_port", guest: 80, host: 8081
    web.vm.synced_folder "./", "/pomodoro.cc", type: "nfs", :mount_options => ['nolock,vers=3,udp,noatime,actimeo=1']
    web.vm.provision "shell", path: "opt/provision_web"
    web.vm.provision "shell", path: "opt/env"
    web.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", 1024]
      vb.customize ["modifyvm", :id, "--cpus", 1]
    end
  end
end
