# Vagrant PHP Development Environment

## Introduction
Developing fast requires a fast development environment being built on every developer computer. We will attempt to make it available under a [VirtualBox](https://www.virtualbox.org) + [Vagrant](https://www.vagrantup.com) + [Docker](https://www.docker.com) provisioning on every operating system, based on Debian Jessie.

## Available tools
Within the development environment, you will find a set of tools that are already configured and ready to use:
* MySQL
* Redis
* Memcached
* RabbitMQ Management (with auto-cluster and webstomp plugins enabled)
* Consul
* Consul Registrator
* Vault with Consul Backend
* VaultUI
* Development WebServer

Looking closely, you will see that this environment is fully targeted for the Microservices architecture, however it will work just fine for a monolithic application.

## Index
* Requirements
* Configuration
* Installation
  * Unix Environment
  * Windows Environment (TODO)
* Final Thoughts

## License
This package is released under MIT License. For more more information please view [LICENSE](/LICENSE) file that is distributed with this source code
