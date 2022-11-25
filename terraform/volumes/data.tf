locals {
  raw_settings = yamldecode(file("${path.module}/../config/config.yml"))

  list_as_map = {for val in local.raw_settings["variables"]:
                 val["key"] => val["value"]}
}