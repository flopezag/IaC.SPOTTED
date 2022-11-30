#
# Create a security group
#
resource "openstack_compute_secgroup_v2" "sec_group" {
    region = ""
    name = "spotted_sec_group"
    description = "Security Group Via Terraform for the virtual nodes"
    rule {
        from_port = 22
        to_port = 22
        ip_protocol = "tcp"
        cidr = "0.0.0.0/0"
    }

    rule {
        from_port = 2377
        to_port = 2377
        ip_protocol = "tcp"
        cidr = "0.0.0.0/0"
    }
}

#
# Create a keypair
#
resource "openstack_compute_keypair_v2" "spotted_keypair" {
  region = var.openstack_region
  name = "spotted_keypair"
}


#
# Create network interface
#
resource "openstack_networking_network_v2" "spotted_network" {
  name = "spotted_network"
  admin_state_up = "true"
  region = var.openstack_region
}

resource "openstack_networking_subnet_v2" "spotted_subnetwork" {
  name = "spotted_subnetwork"
  network_id = openstack_networking_network_v2.spotted_network.id
  cidr = "10.0.0.0/24"
  ip_version = 4
  dns_nameservers = ["8.8.8.8","8.8.4.4"]
  region = var.openstack_region
}

resource "openstack_networking_router_v2" "spotted_router" {
  name = "spotted_router"
  admin_state_up = "true"
  region = var.openstack_region
  external_network_id = data.openstack_networking_network_v2.network.id
}

resource "openstack_networking_router_interface_v2" "spotted_router_interface" {
  router_id = openstack_networking_router_v2.spotted_router.id
  subnet_id = openstack_networking_subnet_v2.spotted_subnetwork.id
  region = var.openstack_region
}


#
# Create an Openstack Floating IP for the virtual machines
#
resource "openstack_compute_floatingip_v2" "spotted_floating_ip" {
    for_each = var.vms
    region   = var.openstack_region
    pool     = var.external_pool
}

#
# Create the VM Instances for SPOTTED
#
resource "openstack_compute_instance_v2" "spotted_virtual_machines" {
  for_each = var.vms

  name = each.value.name
  image_name = var.image
  availability_zone = var.availability_zone
  flavor_name = each.value.flavour
  key_pair = openstack_compute_keypair_v2.spotted_keypair.name
  security_groups = [openstack_compute_secgroup_v2.sec_group.name]

  metadata = {
    description = each.value.description
  }

  network {
    uuid = openstack_networking_network_v2.spotted_network.id
  }
}


#
# Associate public IPs to the virtual machines
#
resource "openstack_compute_floatingip_associate_v2" "associate_floating_ip" {
  for_each = var.vms

  floating_ip = openstack_compute_floatingip_v2.spotted_floating_ip[each.value.id].address
  instance_id = openstack_compute_instance_v2.spotted_virtual_machines[each.value.id].id
}


#
# Attach volumes to the servers
#
resource "openstack_compute_volume_attach_v2" "attachments" {
  count = length(var.vms)

  instance_id = openstack_compute_instance_v2.spotted_virtual_machines[local.server_keys[count.index]].id
  volume_id   = var.volumes[count.index].vol_id
}


# Generate the output files (keypair and inventory) for ansible
locals {
  template_keypair_init = templatefile("${path.module}/../templates/keypair.tpl", {
    keypair = openstack_compute_keypair_v2.spotted_keypair.private_key
  }
  )
}

# Final steps
#resource "null_resource" "configure-virtual-machines-ips" {
#  for_each = var.vms
#
#  connection {
#    user = "ubuntu"
#    host = openstack_compute_floatingip_v2.spotted_floating_ip[each.value.id].address
#    private_key = openstack_compute_keypair_v2.spotted_keypair.private_key
#    agent = true
#    timeout = "3m"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "sudo apt-get update",
#      "sudo apt-get install -y curl",
#    ]
#  }
#}


resource "local_file" "keypair_file" {
  content = local.template_keypair_init
  filename = "keypair"
  file_permission = "0600"
}
