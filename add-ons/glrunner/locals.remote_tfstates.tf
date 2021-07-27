locals {
  landingzone = merge(
    {
      current = {
        storage_account_name = var.tfstate_storage_account_name
        container_name       = var.tfstate_container_name
        resource_group_name  = var.tfstate_resource_group_name
      }
      lower = {
        storage_account_name = var.lower_storage_account_name
        container_name       = var.lower_container_name
        resource_group_name  = var.lower_resource_group_name
      }
      level = var.level
    },
  var.landingzone)
}

data "terraform_remote_state" "remote" {
  for_each = try(var.landingzone.tfstates, {})

  backend = var.landingzone.backend_type
  config = {
    storage_account_name = local.landingzone[try(each.value.level, "current")].storage_account_name
    container_name       = local.landingzone[try(each.value.level, "current")].container_name
    resource_group_name  = local.landingzone[try(each.value.level, "current")].resource_group_name
    key                  = each.value.tfstate
  }
}

locals {
  landingzone_tag = {
    "landingzone" = local.caf_key
  }

  tags = merge(
    local.landingzone_tag,
    { "level" = lookup(var.landingzone, "level", var.level) },
    var.rover_version == null ? {} : { "rover_version" : var.rover_version },
  var.tags)
}
