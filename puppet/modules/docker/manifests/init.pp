# Class: docker
#
# Ensures that the docker engine is installed and that the
# required directories to allow external mount are available
# in the Virtual Machine
#
class docker {

  file {
    [ "/var/docker", "/var/docker/mysql", "/var/docker/mysql/databases", "/var/docker/consul/data" ] :
      ensure => "directory";

    "/var/docker/consul":
      ensure  => "directory",
      purge   => false,
      recurse => true,
      source  => "puppet:///modules/docker/consul";

    "/var/docker/mysql/conf.d":
      ensure  => "directory",
      purge   => false,
      recurse => true,
      source  => "puppet:///modules/docker/mysql/conf.d";

    "/var/docker/nginx":
      ensure  => directory,
      purge   => true,
      recurse => true,
      source  => "puppet:///modules/docker/nginx";
  }
}
