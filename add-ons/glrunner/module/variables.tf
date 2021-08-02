data "azurerm_user_assigned_identity" "msi" {
  name                = "msi-gitlab"
  resource_group_name = "rg-gitlabsrv-daporo001"
}

variable "resource_group_name" {
  description = "Name of the resource group where GitLab Server is deployed"
  type        = string
}

data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

data "azurerm_resources" "vnet" {
  resource_group_name = var.resource_group_name
  type                = "Microsoft.Network/virtualNetworks"
}

variable "vnet_subnet" {
  description = "TODO"
  type        = string
  default     = null
}

variable "gitlab_server_cert" {
  description = "TODO"
  type        = string
  default     = null
}

variable "gitlab_server_internal_ip" {
  description = "TODO"
  type        = string
  default     = null
}

variable "gitlab_server_fqdn" {
  description = "TODO"
  type        = string
  default     = null
}

variable "gitlab_server_token" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_image_publisher" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_image_offer" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_image_sku" {
  description = "TODO"
  type        = string
  default     = null
}


variable "vm_image_version" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_prefix" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_size" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_storage" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_admin_username" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_admin_public_key" {
  description = "TODO"
  type        = string
  default     = null
}

variable "vm_admin_private_key" {
  description = "TODO"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of resource tags to apply to each resource"
  type        = map(any)
  default     = null
}

variable "full_mode" {
  description = "TODO"
  type        = bool
  default     = null
}

variable "ci_workspace" {
  description = "TODO"
  type        = string
}

variable "envs" {
  default = {}
}
