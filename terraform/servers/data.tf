module "yaml_json_multidecoder" {
  source  = "levmel/yaml_json/multidecoder"
  version = "0.2.1"
  filepaths = ["../config/config.yml"]
}

locals {
  vol_keys = keys(module.yaml_json_multidecoder.files.config.volumes)
  server_keys = keys(module.yaml_json_multidecoder.files.config.vms)
}
