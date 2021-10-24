# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :bash => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.101'
  }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "256"]
          end
          
          box.vm.provision "shell", inline: <<-SHELL
            sed -i "s|20/Jul/2021|$(date +'%d/%b/%Y')|i" /vagrant/access.log
            echo "0 * * * * /vagrant/bashscript.sh example@example.com" > cronfile
            crontab cronfile
            rm -rf cronfile
          SHELL
      end
  end
end
