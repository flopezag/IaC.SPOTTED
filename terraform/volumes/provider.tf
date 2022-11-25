provider "openstack" {
  # user_name   = var.openstack_user_name
  # tenant_name = var.openstack_tenant_name
  # password    = var.openstack_password
  # auth_url    = var.openstack_auth_url
  # domain_name = var.openstack_domain_name
  # region      = var.openstack_region

  user_name   = data.template_file.init.openstack_user_name
  tenant_name = data.template_file.init.openstack_tenant_name
  password    = data.template_file.init.openstack_password
  auth_url    = data.template_file.init.openstack_auth_url
  domain_name = data.template_file.init.openstack_domain_name
  region      = data.template_file.init.openstack_region
}

