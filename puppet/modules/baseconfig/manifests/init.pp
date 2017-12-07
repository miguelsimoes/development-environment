# == Class: baseconfig
#
# Ensures that the base configuration for the Virtual Machine
# is applied on every provisiong request
# 
class baseconfig {

  exec { "update-system":
    command => "/usr/bin/apt-get update --fix-missing",
    notify => Exec["upgrade-system"]
  }

  exec { "upgrade-system":
    command => "/usr/bin/apt-get upgrade -y -q",
    require => Exec["update-system"]
  }

  package { 
    "bash-completion": ensure => latest,require => Exec["update-system"];
    "dbus"           : ensure => latest,require => Exec["update-system"];
    "dnsutils"       : ensure => latest,require => Exec["update-system"];
    "eject"          : ensure => purged;
    "git"            : ensure => latest,require => Exec["update-system"];
    "libjpeg-dev"    : ensure => latest,require => Exec["update-system"];
    "nodejs"         : ensure => latest,require => Exec["update-system"];
    "telnet"         : ensure => latest,require => Exec["update-system"];
    "vim"            : ensure => latest,require => Exec["update-system"];
  }

  file {
    "/home/vagrant/.bashrc":
      ensure => present,
      source => "puppet:///modules/baseconfig/bashrc",
      owner  => "vagrant",
      group  => "vagrant";

    "/root/.ssh":
      ensure => directory,
      owner  => "root",
      group  => "root",
      mode   => "0700";

    "/root/.ssh/config":
      ensure => present,
      source => "puppet:///modules/baseconfig/ssh_config",
      owner  => "root",
      group  => "root",
      mode   => "0644";
  }

  exec {
    "update-npm":
      command => "npm install -g npm",
      path    => [ "/bin", "/usr/sbin", "/usr/bin" ],
      require => Package["nodejs"]
  }
}
