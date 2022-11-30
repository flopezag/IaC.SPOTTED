#locals {
#  raw_settings = yamldecode(file("${path.module}/../config/config.yml"))
#
#  list_as_map = {for val in local.raw_settings["variables"]:
#                 val["key"] => val["value"]}
#
#  volumes = {for volumes in local.raw_settings["volumes"]:
#              volumes["key"] => {for data in local.raw_settings["volumes"][volumes["value"]]:
#                data["key"] => data["value"]
#                }
#            }
#}
#
module "yaml_json_multidecoder" {
  source  = "levmel/yaml_json/multidecoder"
  version = "0.2.1"
  filepaths = ["../config/config1.yml"]
}

output "config_variables" {
  value = module.yaml_json_multidecoder.files.config1.variables
}

output "config_volumes" {
  value = module.yaml_json_multidecoder.files.config1.volumes
}

output "config_vms" {
  value = module.yaml_json_multidecoder.files.config1.vms
}

locals {
  vol_keys = keys(module.yaml_json_multidecoder.files.config1.volumes)
  server_keys = keys(module.yaml_json_multidecoder.files.config1.vms)
}

output "vol_keys" {
  value = local.vol_keys
}

output "otro" {
  value = module.yaml_json_multidecoder.files.config1.vms.vm1.id
}