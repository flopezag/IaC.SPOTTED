#
# show the Public IP addresses of the virtual machines and the Private Key
#
output "virtual_machines" {
  value = [ for vm in openstack_compute_floatingip_v2.spotted_floating_ip : "${vm.address} initialized with success"]
}

output "Keypair" {
	value = openstack_compute_keypair_v2.spotted_keypair.private_key
}
