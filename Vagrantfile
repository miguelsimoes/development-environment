# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml";

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  parameters = YAML::load(File.open("config/parameters.yml", File::RDONLY).read)

  # Defines the default username and password to use when authenticating
  # on the VM for the first time. After that, a new RSA key will be generated
  # and used as authentication provider.
  config.ssh.pty        = true

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box_url = "https://cld.pt/dl/download/f9d00ccc-b249-4cdf-92d6-f40d426226c9/package.box"
  config.vm.box = "actualsales-base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Defines the hostname to be used with the VM
  config.vm.hostname = "development.smsimoes.invalid"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: parameters["ip_address"]

  # Uncomment the following if you are under MacOS to have internal DNS
  # resolver available to the host
  # config.dns.tld = "invalid"
  # config.dns.patterns = [ /^.*.invalid$/ ]

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "."              , "/vagrant"
  config.vm.synced_folder "./data/web-root", "/var/www/html", :nfs => parameters["nfs"], owner: "www-data", group: "www-data"
  config.vm.synced_folder "./data/mysql"   , "/var/docker/mysql", :nfs => parameters["nfs"], owner: "vboxadd", group: "root"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
 
    # Customize the name of the VM:
    vb.name = "smsimoes-development-20171208"

    # Customize the amount of memory on the VM:
    vb.memory = "2048"
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    sudo puppet module install puppetlabs/stdlib
    sudo puppet module install willdurand/composer
  SHELL

  #
  # View the documentation for the provider you are using for more
  # information on available options.
  config.vm.provision "puppet" do |puppet|
    puppet.manifest_file  = "main.pp"
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path    = "puppet/modules"
  end

  config.vm.provision "docker" do |docker|
    docker.pull_images "consul:latest"
    docker.pull_images "vault:latest"
    docker.pull_images "gliderlabs/registrator:latest"
    docker.pull_images "memcached:latest"
    docker.pull_images "mysql:5.6"
    docker.pull_images "redis:latest"
    docker.pull_images "smsimoes/rabbitmq-autocluster:latest"
    docker.pull_images "smsimoes/development-web-server:latest"
    docker.pull_images "djenriquez/vault-ui:latest"

    docker.run "consul"     , image: "consul:latest"                         , args: "-p 8300:8300 -p 8301:8301 -p 8302:8302 -p 8500:8500 -p 53:8600 -p 8301:8301/udp -p 8302:8302/udp -p 53:8600/udp -v /var/docker/consul/config:/consul/config -v /var/docker/consul/data:/consul/data -e SERVICE_8300_NAME=consul-rpc -e SERVICE_8301_NAME=consul-serf-lan -e SERVICE_8302_NAME=consul-serf-wan -e SERVICE_8500_NAME=consul-interface -e SERVICE_8600_NAME=consul-dns", cmd: "agent -server -bootstrap-expect=1 -ui"
    docker.run "registrator", image: "gliderlabs/registrator:latest"	       , args: "-v /var/run/docker.sock:/tmp/docker.sock"                                      , cmd: "consul://10.100.10.15:8500"
    docker.run "vault"      , image: "vault:latest"                          , args: "--dns=172.17.0.1 --dns-search service.consul --dns-search node.consul -p 8200:8200 -p 8201:8201 -v /var/docker/vault/logs:/vault/logs -v /var/docker/vault/file:/vault/file -v /var/docker/vault/config:/vault/config -e SKIP_SETCAP=true -e SERVICE_8200_NAME=vault -e SERVICE_8201_NAME=vault-cluster", cmd: "server"
    docker.run "vault-ui"   , image: "djenriquez/vault-ui:latest"            , args: "--dns=172.17.0.1 --dns-search service.consul --dns-search node.consul -p 8280:8000 -e NODE_TLS_REJECT_UNAUTHORIZED=0 -e VAULT_URL_DEFAULT=http://172.17.0.1:8200 -e VAULT_AUTH_DEFAULT=TOKEN"
    docker.run "memcached"  , image: "memcached:latest"                      , args: "-p 11211:11211 -e SERVICE_11211_NAME=memcached"
    docker.run "mysql"      , image: "mysql:5.6"                             , args: "-p 3306:3306 -v /var/docker/mysql/conf.d:/etc/mysql/conf.d -v /var/docker/mysql/databases:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=vagrant -e SERVICE_3306_NAME=mysql"
    docker.run "rabbitmq"   , image: "smsimoes/rabbitmq-autocluster:latest"  , args: "-p 15672:15672 -p 5672:5672 -p 15674:15674 -v /var/docker/rabbitmq:/var/lib/rabbitmq -e SERVICE_15674_NAME=rabbitmq-stomp -e SERVICE_5672_NAME=rabbitmq -e SERVICE_15672_NAME=rabbitmq-management" 
    docker.run "redis"      , image: "redis:latest"                          , args: "-p 6379:6379 -v /var/docker/redis/databases:/data -e SERVICE_6379_NAME=redis", cmd: "--appendonly yes"
    docker.run "web-server" , image: "smsimoes/development-web-server:latest", args: "--dns=172.17.0.1 --dns-search service.consul --dns-search node.consul -p 80:80 -v /var/www/html:/var/www/html -v /var/docker/nginx/sites-enabled:/opt/openresty/nginx/conf/sites-enabled -e SERVICE_80_NAME=web-applications"
  end

  config.vm.provision "shell", run: "always", inline: <<-SHELL
     systemctl list-unit-files | grep enabled | grep docker.service
     if [ $? -ne 1 ]; then
      systemctl stop docker
      systemctl disable docker
     fi
     
  SHELL

  config.vm.provision "shell", run: "always", inline: <<-SHELL
    #
    # And we need to ensure that the docker daemon is restart so we get the mounts available from the host
    systemctl start docker
  SHELL

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end
end
