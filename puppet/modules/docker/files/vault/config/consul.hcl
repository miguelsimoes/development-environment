disable_cache = true
disable_mlock = true

ui = true

backend "consul" {
	address = "172.17.0.1:8500",
	path    = "development-vault",
}

listener "tcp" {
	address = "0.0.0.0:8200"
	cluster_address = "0.0.0.0:8201"
	tls_disable = true
}

max_lease_ttl = "10h"
default_lease_ttl = "10h"
raw_storage_endpoint = true
