provider "openstack" {
  user_name   = local.list_as_map["openstack_user_name"]
  tenant_name = local.list_as_map["openstack_tenant_name"]
  password    = local.list_as_map["openstack_password"]
  auth_url    = local.list_as_map["openstack_auth_url"]
  domain_name = local.list_as_map["openstack_domain_name"]
  region      = local.list_as_map["openstack_region"]

}

