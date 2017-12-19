# == Class: php
#
# Ensures that PHP is installed on the Virtual Machine
class php {

  exec { 
    "add-dotdeb-repository-key":
      path    => ["/bin", "/usr/bin"],
      command => "wget --quiet -O - https://www.dotdeb.org/dotdeb.gpg | apt-key add -",
      notify  => Exec["add-dotdeb-repository"];

    "add-dotdeb-repository":
      path    => [ "/bin", "/usr/bin", "/usr/sbin" ],
      command => 'echo "deb http://packages.dotdeb.org jessie all" | tee /etc/apt/sources.list.d/dotdeb.list',
      require => Exec["add-dotdeb-repository-key"],
      notify  => Exec["update-dotdeb-packages"];

    "update-dotdeb-packages":
      path    => [ "/usr/bin"],
      command => 'sudo apt update -y -qq',
      require => Exec["add-dotdeb-repository"],
  }

  package { ["php7.0-cli", "php7.0-curl", "php7.0-memcached", "php7.0-mongodb", "php7.0-mysql"]:
    require => Exec["update-dotdeb-packages"],
    ensure  => present;
  }

  class { "::composer": 
    command_name => "composer",
    target_dir   => "/usr/local/bin",
    auto_update  => true,
    require      => Package["php7.0-cli"]
  }
}
