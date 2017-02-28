# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant guest config #
if !File.exist?('./config.rb')
    FileUtils.cp('./config-sample.rb', './config.rb')
end

# Copy config.rb.sample to config.rb and modify to customize the environment
CONFIG = File.join(File.dirname(__FILE__), "config.rb")
require CONFIG

# End Vagrant guest config #

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", type: "dhcp"

  $ansible_groups = { "vagrant" => [ ] }

$boxes.each_with_index do |box, index|
  # Sets of redundant clusters only
  (1..box[:cluster_size] ||= 1).each do |i|
    # Define names based on first group to allow for dynamic role changes without new
    config.vm.define vm_name = "%s-%02d" % [box[:ansible][0][:group], i] do |node|
      node.vm.hostname = vm_name
      # Generate Ansible groups to provide inventory to match playbook structure
      box[:ansible].each do |box_group|
        cluster_group = "%sservers:children" % box_group[:group]
        box_group[:roles].each do |cluster_role|
          unless $ansible_groups.has_key?(cluster_group)
            $ansible_groups[cluster_group] = [ cluster_role ]
          else
            $ansible_groups[cluster_group].push(cluster_role)
          end

          unless $ansible_groups.has_key?(cluster_role)
            $ansible_groups[cluster_role] = [ vm_name ]
          else
            $ansible_groups[cluster_role].push(vm_name)
          end
        end
      end
      $ansible_groups["vagrant"].push(vm_name)
      #node.vm.box = "%s-%s" % [box[:os] ||= "ubuntu", box[:os_version] ||= "14.04"]

      ## Virtualization - Oracle VirtualBox
      node.vm.provider :virtualbox do |v|
        # https://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
        v.customize ["modifyvm", :id, "--memory", box[:ram] ||= 512]
        v.customize ["modifyvm", :id, "--cpuhotplug", "on"]
        v.customize ["modifyvm", :id, "--cpus", box[:cpus] ||= 2]
        v.customize ["modifyvm", :id, "--chipset", "ich9"]
        v.customize ["modifyvm", :id, "--hpet", "on"]
        v.customize ["modifyvm", :id, "--hwvirtex", "on"]
        v.customize ["modifyvm", :id, "--nestedpaging", "on"]
        v.customize ["modifyvm", :id, "--largepages", "on"]
        v.customize ["modifyvm", :id, "--vtxvpid", "on"]
        v.customize ["modifyvm", :id, "--vtxux", "on"]
        v.customize ["modifyvm", :id, "--ioapic", "on"]
        v.customize ["modifyvm", :id, "--nictype1", "virtio"]
        v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--nictype2", "virtio"]
        v.customize ["modifyvm", :id, "--natdnsproxy2", "on"]
        v.customize ["modifyvm", :id, "--natdnshostresolver2", "on"]
      end

      box[:forwarded_ports].each do |guest_port, host_port|
        node.vm.network "forwarded_port", guest: guest_port, host: host_port, auto_correct: true
      end if box[:forwarded_ports]
    end
  end
end
end
