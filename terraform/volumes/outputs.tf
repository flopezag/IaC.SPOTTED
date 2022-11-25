#
# show the Public and Private IP addresses of the virtual machines
#
output "SpottedPortal_Vol" {
  value =  openstack_blockstorage_volume_v2.volume["vol1"].id
}

output "Idra_Vol" {
  value =  openstack_blockstorage_volume_v2.volume["vol2"].id
}
