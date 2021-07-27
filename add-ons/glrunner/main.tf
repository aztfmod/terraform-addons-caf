terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.69"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.1"
    }

  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {
  }
}

#TODO: Unclear why this is needed.
data "azurerm_client_config" "current" {}

locals {

  # Rover will fill in level as per command line, but let user override it via landingzone
  caf_level = lookup(var.landingzone, "level", var.level)
  caf_key   = lookup(var.landingzone, "key", var.tfstate_key)

  backend = {
    azurerm = {
      storage_account_name = var.tfstate_storage_account_name
      container_name       = var.tfstate_container_name
      resource_group_name  = var.tfstate_resource_group_name
      key                  = var.tfstate_key
      level                = local.caf_level
      tenant_id            = var.tenant_id
      subscription_id      = data.azurerm_client_config.current.subscription_id
    }
  }

  tags_computed = merge(
    {
      caf_level    = local.caf_level,
      caf_stateKey = local.caf_key,
      caf_state    = var.tf_name,
      environment  = var.environment,
    },
  var.tags)

}
