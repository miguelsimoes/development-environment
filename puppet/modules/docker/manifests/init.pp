# Class: docker
#
# Ensures that the docker engine is installed and that the
# required directories to allow external mount are available
# in the Virtual Machine
#
class docker {

  file {
    [ "/var/docker", "/var/docker/consul", "/var/docker/consul/data", "/var/docker/mysql", "/var/docker/mysql/databases", "/var/docker/redis", "/var/docker/redis/databases", "/var/docker/vault", "/var/docker/vault/file", "/var/docker/vault/logs" ] :
      ensure => "directory";

    "/etc/docker/daemon.json":
      source => "puppet:///modules/docker/etc/daemon.json";

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
