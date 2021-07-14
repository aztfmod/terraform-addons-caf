data "azurerm_user_assigned_identity" "msi" {
  name                = "msi-gitlab"
  resource_group_name = "rg-gitlabsrv-daporo001"
}

data "azurerm_resource_group" "resource_group" {
  name = "rg-gitlabsrv-daporo001"
}

data "azurerm_resources" "vnet" {
  resource_group_name = data.azurerm_resource_group.resource_group.name
  type                = "Microsoft.Network/virtualNetworks"
}

data "azurerm_resources" "msi_id" {
  type = "Microsoft.ManagedIdentity"
  required_tags = {
    environment = "${var.caf_environment}"
    level       = "1"
  }
}

variable "caf_environment" {
  type    = string
  default = "test"
}

variable "gitlab_server" {
  type = map(string)
  default = {
    cert_path   = "/mnt/c/dev/aztfmod/symphony/.data/ssl/server.crt"
    internal_ip = "10.0.0.4"
    fqdn        = "daporogl.westus2.cloudapp.azure.com"
    token       = "dheprk2Mzv8teJHi78sQ"
  }
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
    username    = "gitlab"
    public_key  = "~/.ssh/id_rsa.pub"
    private_key = "~/.ssh/id_rsa"
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
  default = 1
}