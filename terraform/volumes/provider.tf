provider "openstack" {
  user_name   = module.yaml_json_multidecoder.files.config1.variables.openstack_user_name
  tenant_name = module.yaml_json_multidecoder.files.config1.variables.openstack_tenant_name
  password    = module.yaml_json_multidecoder.files.config1.variables.openstack_password
  auth_url    = module.yaml_json_multidecoder.files.config1.variables.openstack_auth_url
  domain_name = module.yaml_json_multidecoder.files.config1.variables.openstack_domain_name
  region      = module.yaml_json_multidecoder.files.config1.variables.openstack_region
}

