# Variables from the users's TF file

variable "jenkinsServers" {
  description = "A map of server information with keys == Servername"
  type = map
}

variable "tags" {
  description = "Any desired overrides for resource tag key/values.  See module output for details on tag names."
  type = map
  default = null
}

# Variables set by the Rover comand.
#
# The are exported from rover via environment variables.  e.g.,
# https://github.com/aztfmod/rover/blob/5e65914803542638a262cc2f87d17f77cb06007c/scripts/tfc.sh#L167

variable "tenant_id" {
    description = "The Azure Tenant ID housing the state.  e.g., 73f988be-84f1-41bf-91fb-2d7aa011ec48"
    type = string
}

variable "tfstate_subscription_id" {
    description = "Subscription housing the state for the level specified on the rover command."
    type = string
}

variable "tfstate_resource_group_name" {
    description = "Resource group housing the state for the level specified on the rover command."
    type = string
}

variable "lower_resource_group_name" {
    description = "Resource group housing the state at one below the level specified on the rover command."
    type = string
}

variable "tfstate_storage_account_name" {
    description = "Storage Account for the state level specified on the rover command.  e.g., level1"
    type = string
}
variable "lower_storage_account_name" {
  description = "Storage Account for state at one below the level specified on the rover command.  e.g., level0"
  type = string
}
variable "tfstate_container_name" {
  description = "Storage container name for the state level specified on the rover command."
  type = string
}
variable "lower_container_name" {
  description = "Storage container name for the state at one below the level specified on the rover command."
  type = string
}

variable "level" {
  description = "The level specified on the rover command. e.g., level1"
  type = string
}

variable "environment" {
  description = "The environment name specified (via -env) on the rover command. e.g., myProduction"
  type = string
}

variable "rover_version" {
  description = "the version of the rover command"
  type = string
  default = null
}

variable "tf_name" {
  description = "The state file/blob name (usually the tfstate filename). e.g., mystate.tfstate"
  type = string
}

variable "tfstate_key" {
  description = "The name of the state, which can be used to index the tfstates map. e.g., mystate.tfstate"
  type = string
}

variable "landingzone" {
  default = {
    backend_type        = "azurerm"
    global_settings_key = "launchpad"
    level               = "level1"
    key                 = "jenkins"
    tfstates = {
      launchpad = {
        level   = "lower"
        tfstate = "caf_launchpad.tfstate"
      }
    }
  }
}

#####################################
#Debugging
#output "VarLandingZone" { value = var.landingzone }
#output "VarTags" { value = var.tags }
