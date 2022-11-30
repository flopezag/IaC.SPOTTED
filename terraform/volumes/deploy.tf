# Deploy the volumes
resource "openstack_blockstorage_volume_v2" "volume" {
  count = length(local.vol_keys)

  name                = module.yaml_json_multidecoder.files.config1.volumes[local.vol_keys[count.index]].name
  description         = module.yaml_json_multidecoder.files.config1.volumes[local.vol_keys[count.index]].description
  size                = module.yaml_json_multidecoder.files.config1.volumes[local.vol_keys[count.index]].size
}

resource "null_resource" "volume_list" {
  count = length(local.vol_keys)

  triggers = {
      vol_name = module.yaml_json_multidecoder.files.config1.volumes[local.vol_keys[count.index]].name,
      vol_id   = openstack_blockstorage_volume_v2.volume[count.index].id,
      vol_vm   = module.yaml_json_multidecoder.files.config1.volumes[local.vol_keys[count.index]].vm
  }
}

# Generate the output file for servers creation
#locals {
#  template_volume = templatefile("${path.module}/../templates/volume.tftpl",
#    {
#      openstack_user_name = local.settings.variables.openstack_user_name,
#      openstack_tenant_name = local.settings.variables.openstack_tenant_name,
#      openstack_password = local.settings.variables.openstack_password,
#      openstack_auth_url = local.settings.variables.openstack_auth_url,
#      openstack_region = local.settings.variables.openstack_region,
#      openstack_domain_name = local.settings.variables.openstack_domain_name,
#      volume_list = [
#        {
#          (openstack_blockstorage_volume_v2.volume["vol1"].name) = openstack_blockstorage_volume_v2.volume["vol1"].id
#        },
#        {
#          (openstack_blockstorage_volume_v2.volume["vol2"].name) = openstack_blockstorage_volume_v2.volume["vol2"].id
#        }
#      ]
#    }
#  )
#}
#
#resource "local_file" "volume__file" {
#  content = local.template_volume
#  filename = "../servers/terraform.tfvars"
#  file_permission = "0600"
#}
#
locals {
  template_servers = templatefile("${path.module}/../templates/servers.tftpl",
    {
      openstack_user_name = module.yaml_json_multidecoder.files.config1.variables.openstack_user_name,
      openstack_tenant_name = module.yaml_json_multidecoder.files.config1.variables.openstack_tenant_name,
      openstack_password = module.yaml_json_multidecoder.files.config1.variables.openstack_password,
      openstack_auth_url = module.yaml_json_multidecoder.files.config1.variables.openstack_auth_url,
      openstack_region = module.yaml_json_multidecoder.files.config1.variables.openstack_region,
      openstack_domain_name = module.yaml_json_multidecoder.files.config1.variables.openstack_domain_name,
      openstack_image = module.yaml_json_multidecoder.files.config1.variables.base_image,
      ssh_key_pair = module.yaml_json_multidecoder.files.config1.variables.ssh_key_pair,
      ssh_user_name = module.yaml_json_multidecoder.files.config1.variables.ssh_user_name,
      availability_zone = module.yaml_json_multidecoder.files.config1.variables.availability_zone,
      external_pool = module.yaml_json_multidecoder.files.config1.variables.external_pool,

      servers_list = module.yaml_json_multidecoder.files.config1.vms,
      volume_list = null_resource.volume_list.*.triggers
    }
  )
}


resource "local_file" "servers__file" {
  content = local.template_servers
  filename = "../servers/variables.tf"
  file_permission = "0600"
}

output "quest" {
  value = null_resource.volume_list.*.triggers
}