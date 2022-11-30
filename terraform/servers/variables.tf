variable "openstack_user_name" {}

variable "openstack_tenant_name" {}

variable "openstack_password" {}

variable "openstack_auth_url" {}

variable "openstack_region" {}

variable "openstack_domain_name" {}

variable openstack_volume_SpottedPortal_Vol {}

variable openstack_volume_Idra_Vol {}

variable "image" {
  default = "base_ubuntu_22.04"
}

variable "ssh_key_pair" {
  default = "fla"
}

variable "ssh_user_name" {
  default = "ubuntu"
}

variable "availability_zone" {
  default = "nova"
}

variable "external_pool" {
  default = "public-ext-net-01"
}

variable "vms" {
  description = "Virtual Machines"
  type = map(
    object({
      id = string,
      name = string,
      description = string,
      flavour = string
    })
  )
  default = {
  vm1 = {
        id              = "vm1"
        name            = "SPOTTEDPortal"
        description     = "SPOTTED VM for the Spotted Portal"
        flavour         = "medium"
    }
  vm2 = {
        id              = "vm2"
        name            = "Idra"
        description     = "SPOTTED VM for the Spotted Portal"
        flavour         = "large"
  }
 }
}
