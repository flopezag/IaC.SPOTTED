#
# Deploy the volumes
#
resource "openstack_blockstorage_volume_v2" "volume" {
  count = length(local.vol_keys)

  name                = module.yaml_json_multidecoder.files.config.volumes[local.vol_keys[count.index]].name
  description         = module.yaml_json_multidecoder.files.config.volumes[local.vol_keys[count.index]].description
  size                = module.yaml_json_multidecoder.files.config.volumes[local.vol_keys[count.index]].size
}


#
# Generate the output file for servers creation
#
resource "null_resource" "volume_list" {
  count = length(local.vol_keys)

  triggers = {
      vol_name = module.yaml_json_multidecoder.files.config.volumes[local.vol_keys[count.index]].name,
      vol_id   = openstack_blockstorage_volume_v2.volume[count.index].id,
      vol_vm   = module.yaml_json_multidecoder.files.config.volumes[local.vol_keys[count.index]].vm
  }
}

locals {
  vol_dict = {
    for i in local.server_keys :
        i => [for k, v in module.yaml_json_multidecoder.files.config.volumes: tostring(openstack_blockstorage_volume_v2.volume[index(local.vol_keys, k)].id) if v.vm == i]
    }
}

output "caci1" {
  value = local.server_keys
}

output "caci2" {
  value = module.yaml_json_multidecoder.files.config.volumes
}

output "caci3" {
  value = local.vol_dict
}

output "index" {
  value = index(local.vol_keys, "vol3")
}

locals {
  template_volume = templatefile("${path.module}/../templates/volume.tftpl",
    {
      openstack_user_name = module.yaml_json_multidecoder.files.config.variables.openstack_user_name,
      openstack_tenant_name = module.yaml_json_multidecoder.files.config.variables.openstack_tenant_name,
      openstack_password = module.yaml_json_multidecoder.files.config.variables.openstack_password,
      openstack_auth_url = module.yaml_json_multidecoder.files.config.variables.openstack_auth_url,
      openstack_region = module.yaml_json_multidecoder.files.config.variables.openstack_region,
      openstack_domain_name = module.yaml_json_multidecoder.files.config.variables.openstack_domain_name,
    }
  )
}

resource "local_file" "volume__file" {
  content = local.template_volume
  filename = "../servers/terraform.tfvars"
  file_permission = "0600"
}


locals {
  template_servers = templatefile("${path.module}/../templates/servers.tftpl",
    {
      openstack_user_name = module.yaml_json_multidecoder.files.config.variables.openstack_user_name,
      openstack_tenant_name = module.yaml_json_multidecoder.files.config.variables.openstack_tenant_name,
      openstack_password = module.yaml_json_multidecoder.files.config.variables.openstack_password,
      openstack_auth_url = module.yaml_json_multidecoder.files.config.variables.openstack_auth_url,
      openstack_region = module.yaml_json_multidecoder.files.config.variables.openstack_region,
      openstack_domain_name = module.yaml_json_multidecoder.files.config.variables.openstack_domain_name,
      openstack_image = module.yaml_json_multidecoder.files.config.variables.base_image,
      ssh_key_pair = module.yaml_json_multidecoder.files.config.variables.ssh_key_pair,
      ssh_user_name = module.yaml_json_multidecoder.files.config.variables.ssh_user_name,
      availability_zone = module.yaml_json_multidecoder.files.config.variables.availability_zone,
      external_pool = module.yaml_json_multidecoder.files.config.variables.external_pool,

      servers_list = module.yaml_json_multidecoder.files.config.vms,
      volume_list = null_resource.volume_list.*.triggers,

      volume_dict = local.vol_dict
    }
  )
}

resource "local_file" "servers__file" {
  content = local.template_servers
  filename = "../servers/variables.tf"
  file_permission = "0600"
}
