require 'ipaddr'

hostname        = "idp"
domain          = "example.org"
fqdn_name       = "#{hostname}.#{domain}"
ip_address      = IPAddr.new('192.168.64.10')
machinesNames   = Array["idp"]
machines        = Hash.new

#  Determine IP addresses to the VMs.
machinesNames.each { |machineName|
    machines.store(machineName, ip_address.to_s)
    ip_address = ip_address.succ
}

$python2 = <<SCRIPT
apt-get update
apt-get install -y python
SCRIPT

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial64"
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = false
    config.hostmanager.manage_guest = true
    config.hostmanager.ignore_private_ip = false
    config.hostmanager.include_offline = true

    config.vm.define "target" do |target|
        target.vm.provider "virtualbox" do |vbox|
            vbox.memory = 1024
            vbox.name = "idp"
        end

        target.vm.network "private_network", ip: "#{machines["idp"]}"
        target.vm.hostname = "#{fqdn_name}"

        target.vm.provision "shell", inline: $python2

        target.vm.provision "ansible" do |ansible|
            ansible.playbook = "openconext-diy.yml"

            ansible.groups = {
                "idp" => ["target"],

                "idp:vars" => {
                    "idp_hostname" => "#{fqdn_name}",
                    "idp_sp" => "https://sp.example.org",
                    "letsencrypt_email" => "idp@example.org",
                    "cert_subject" => "/C=US/ST=Nowhere/L=MyTown/O=IT/CN=#{fqdn_name}"
                }
            }
        end
    end
end
