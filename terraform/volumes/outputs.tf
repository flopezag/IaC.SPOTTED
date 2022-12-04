#
# show the Public and Private IP addresses of the virtual machines
#
output "Volumes" {
  value = ["${openstack_blockstorage_volume_v2.volume.*.id}"]
}
