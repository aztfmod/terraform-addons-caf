data "azurerm_resource_group" "resource_group" {
  name = "rg-gitlabsrv-daporo001"
}

data "azurerm_resources" "vnet" {
  resource_group_name = data.azurerm_resource_group.resource_group.name
  type                = "Microsoft.Network/virtualNetworks"
}

variable "vnet_subnet" {
  type    = string
  default = "gitlab-serverSubnet"
}

variable "vm_prefix" {
  type    = string
  default = "gl-runner"
}

variable "vm_image" {
  type = map(string)
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "vm_admin" {
  type = map(string)
  default = {
    username   = "gitlab"
    public_key = "~/.ssh/id_rsa.pub"
  }
}

variable "vm_size" {
  type    = string
  default = "Standard_D8s_v3"
}

variable "vm_storage" {
  type    = string
  default = "Premium_LRS"
}

variable "vm_count" {
  type    = number
  default = 2
}