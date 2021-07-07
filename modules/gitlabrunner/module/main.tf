terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.66.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.vm_prefix}-${count.index}-nic"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${data.azurerm_resources.vnet.resources[0].id}/subnets/${var.vnet_subnet}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.pip.*.id, count.index)
  }
}

resource "azurerm_public_ip" "pip" {
  count               = var.vm_count
  name                = "${var.vm_prefix}-${count.index}-pip"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_security_group" "nsg" {
  count               = var.vm_count
  name                = "${var.vm_prefix}-${count.index}-nsg"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  security_rule {
    name                       = "default-allow-ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  count                     = var.vm_count
  subnet_id                 = "${data.azurerm_resources.vnet.resources[0].id}/subnets/${var.vnet_subnet}"
  network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)
}

resource "azurerm_linux_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "${var.vm_prefix}-${count.index}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  size                = var.vm_size
  admin_username      = var.vm_admin["username"]

  network_interface_ids = [
    "${element(azurerm_network_interface.nic.*.id, count.index)}"
  ]

  admin_ssh_key {
    username   = var.vm_admin["username"]
    public_key = file(var.vm_admin["public_key"])
  }

  source_image_reference {
    publisher = var.vm_image["publisher"]
    offer     = var.vm_image["offer"]
    sku       = var.vm_image["sku"]
    version   = var.vm_image["version"]
  }

  os_disk {
    storage_account_type = var.vm_storage
    caching              = "ReadWrite"
  }
}