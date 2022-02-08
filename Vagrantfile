# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
        libvirt.driver = "kvm"
        libvirt.memory = 8096
        libvirt.cpus = 4
end
  config.vm.box = "generic/ubuntu2004"
  config.vm.provision:shell, inline: <<-SHELL
        echo "root:rootroot" | sudo chpasswd
        sudo timedatectl set-timezone America/Montevideo #change this to your timezone
  SHELL

  config.vm.define "carbonio" do |ubuntu|
        ubuntu.vm.hostname = "carbonio" # change this to your hostname
  end
   config.vm.network "public_network", 
   ip: "172.16.0.200",
   :dev => 'virbr1',
   :mode => 'bridge',
   :type => 'bridge'
  # default router  
   config.vm.provision "shell",
   run: "always",
   inline: "ip route add default via 172.16.0.1"
   
   config.vm.provision:shell, path: "bootstrap.sh"
end
