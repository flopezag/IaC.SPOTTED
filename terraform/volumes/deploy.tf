# Deploy the volumes
resource "openstack_blockstorage_volume_v2" "volume" {
  for_each            = var.volumes
  name                = each.value.name
  description         = each.value.description
  size                = each.value.size
}

# Generate the output file for servers creation
locals {
  template_volume = templatefile("${path.module}/../templates/volume.tftpl",
    {
      openstack_user_name = local.list_as_map["openstack_user_name"],
      openstack_tenant_name = local.list_as_map["openstack_tenant_name"],
      openstack_password = local.list_as_map["openstack_password"],
      openstack_auth_url = local.list_as_map["openstack_auth_url"],
      openstack_region = local.list_as_map["openstack_region"],
      openstack_domain_name = local.list_as_map["openstack_domain_name"],
      volume_list = [
        {
          (openstack_blockstorage_volume_v2.volume["vol1"].name) = openstack_blockstorage_volume_v2.volume["vol1"].id
        },
        {
          (openstack_blockstorage_volume_v2.volume["vol2"].name) = openstack_blockstorage_volume_v2.volume["vol2"].id
        }
      ]
    }
  )
}

resource "local_file" "volume__file" {
  content = local.template_volume
  filename = "../servers/terraform.tfvars"
  file_permission = "0600"
}
