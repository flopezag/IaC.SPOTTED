data "template_file" "init" {
  value = yamldecode(file("${path.module}/../config/config.yml"))

  openstack_user_name = value["openstack_user_name"]
  openstack_tenant_name = value["openstack_tenant_name"]
  openstack_password = value["openstack_password"]
  openstack_auth_url = value["openstack_auth_url"]
  openstack_region = value["openstack_region"]
  openstack_domain_name = value["openstack_domain_name"]
  openstack_flavor = value["openstack_flavor"]
}