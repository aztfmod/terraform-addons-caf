variable "runner" {
  description = "The object representative of the ado project entity to update."
  type        = map(any)
}

data "azurerm_user_assigned_identity" "msi" {
  name                = lookup(var.runner, "msi_name", "") #"msi-gitlab"
  resource_group_name = lookup(var.runner, "msi_resource_group_name", "") #"rg-gitlabsrv-daporo001"
}

data "azurerm_resource_group" "resource_group" {
  name = lookup(var.runner, "gitlab_server_resource_group", "") #"rg-gitlabsrv-daporo001"
}

data "azurerm_resources" "vnet" {
  resource_group_name = lookup(var.runner, "gitlab_server_resource_group", "") #data.azurerm_resource_group.resource_group.name
  type                = "Microsoft.Network/virtualNetworks"
}

# variable "caf_environment" {
#   type    = string
#   default = "test"
# }

# variable "gitlab_server" {
#   type = map(string)
#   default = {
#     cert_path   = "/mnt/c/dev/aztfmod/symphony/.data/ssl/server.crt"
#     internal_ip = "10.0.0.4"
#     fqdn        = "daporogl.westus2.cloudapp.azure.com"
#     token       = "6aByVYccdavafXZsez4Z"
#   }
# }

# variable "vnet_subnet" {
#   type    = string
#   default = "gitlab-serverSubnet"
# }

# variable "vm_prefix" {
#   type    = string
#   default = "gl-runner"
# }

# variable "vm_image" {
#   type = map(string)
#   default = {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
# }

# variable "vm_admin" {
#   type = map(string)
#   default = {
#     username    = "gitlab"
#     public_key  = "~/.ssh/id_rsa.pub"
#     private_key = "~/.ssh/id_rsa"
#   }
# }

# variable "vm_size" {
#   type    = string
#   default = "Standard_D8s_v3"
# }

# variable "vm_storage" {
#   type    = string
#   default = "Premium_LRS"
# }

# variable "vm_count" {
#   type    = number
#   default = 1
# }