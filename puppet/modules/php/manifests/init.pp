# == Class: php
#
# Ensures that PHP is installed on the Virtual Machine
class php {

  exec { 
    "add-repository-key":
      path    => ["/bin", "/usr/bin"],
      command => "wget --quiet -O - https://www.dotdeb.org/dotdeb.gpg | apt-key add -",
      notify  => Exec["add-repository"];

    "add-repository":
      path    => [ "/bin", "/usr/bin", "/usr/sbin" ],
      command => 'echo "deb http://packages.dotdeb.org jessie all" | tee /etc/apt/sources.list.d/dotdeb.list',
      notify  => Exec["update-repositories"],
      require => Exec["add-repository-key"];

    "update-repositories":
      path    => [ "/usr/bin" ],
      command => "apt update -y -qq",
      require => Exec["add-repository"];
  }

  package { ["php7.0-cli", "php7.0-curl", "php7.0-memcached", "php7.0-mongodb", "php7.0-mysql"]:
    require => [ Exec["add-repository-key"], Exec['add-repository'], Exec['update-repositories'] ],
    ensure  => present;
  }

  class { "::composer": 
    command_name => "composer",
    target_dir   => "/usr/local/bin",
    auto_update  => true
  }
}
