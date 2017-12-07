#
# Base puppet provisioner to ensure that all modules and
# possible configurations and logic are applied during 
# provisiong
#
stage { "pre":
  before => Stage["main"]
}

class { "baseconfig":
  stage => "pre"
}
#
# Set the defaults for the file permissions
File {
  owner => "root",
  group => "root",
  mode  => "0644"
}

include baseconfig, docker, php
