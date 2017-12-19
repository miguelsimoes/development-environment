# Class: docker
#
# Ensures that the docker engine is installed and that the
# required directories to allow external mount are available
# in the Virtual Machine
#
class docker {
  exec {
    "add-docker-repository-key":
      path    => [ "/usr/bin" ],
      command => 'curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -',
      notify  => Exec["add-docker-repository"];

    "add-docker-repository":
      path    => [ "/usr/bin" ],
      command => 'sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"',
      require => Exec["add-docker-repository-key"],
      notify  => Exec["update-docker-packages"];

    "update-docker-packages":
      path    => [ "/usr/bin"],
      command => 'sudo apt update -y -qq',
      require => Exec["add-docker-repository"],
      notify  => Package["docker-ce"];
  }

  package {
    "docker-ce":
      ensure  => present,
      require => Exec["update-docker-packages"];
  }

  file {
    [ "/var/docker", "/var/docker/consul", "/var/docker/consul/data", "/var/docker/mysql", "/var/docker/mysql/databases", "/var/docker/redis", "/var/docker/redis/databases", "/var/docker/vault", "/var/docker/vault/file", "/var/docker/vault/logs" ] :
      ensure  => "directory";

    "/etc/docker/daemon.json":
      source => "puppet:///modules/docker/etc/daemon.json",
      require => Package["docker-ce"];

    "/var/docker/consul/config":
      ensure  => "directory",
      purge   => false,
      recurse => true,
      source  => "puppet:///modules/docker/services/consul/config";

    "/var/docker/mysql/conf.d":
      ensure  => "directory",
      purge   => false,
      recurse => true,
      source  => "puppet:///modules/docker/services/mysql/conf.d";

    "/var/docker/nginx":
      ensure  => directory,
      purge   => true,
      recurse => true,
      source  => "puppet:///modules/docker/services/nginx";

    "/var/docker/vault/config":
      ensure  => "directory",
      purge   => false,
      recurse => true,
      source  => "puppet:///modules/docker/services/vault/config";
  }
}
