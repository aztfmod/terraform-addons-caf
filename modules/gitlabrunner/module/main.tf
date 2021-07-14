terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.67.0"
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
  domain_name_label   = "${var.vm_prefix}-${count.index}"
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

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  count                     = var.vm_count
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)
}

resource "azurerm_role_assignment" "assign_msi" {
  scope                = data.azurerm_resource_group.resource_group.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_user_assigned_identity.msi.principal_id
}


resource "azurerm_linux_virtual_machine" "vm" {
  depends_on = [
    azurerm_role_assignment.assign_msi
  ]
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

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.msi.id]
  }

  custom_data = filebase64("./runner/cloud-config.yml")

  provisioner "file" {
    source      = "./runner/custom-agent"
    destination = "~/"

    connection {
      type        = "ssh"
      user        = var.vm_admin["username"]
      private_key = file(var.vm_admin["private_key"])
      host        = element(azurerm_public_ip.pip.*.fqdn, count.index)
    }
  }

  provisioner "file" {
    source      = var.gitlab_server["cert_path"]
    destination = "~/custom-agent/gitlab.crt"

    connection {
      type        = "ssh"
      user        = var.vm_admin["username"]
      private_key = file(var.vm_admin["private_key"])
      host        = element(azurerm_public_ip.pip.*.fqdn, count.index)
    }
  }

  provisioner "file" {
    source      = var.gitlab_server["cert_path"]
    destination = "~/gitlab.crt"

    connection {
      type        = "ssh"
      user        = var.vm_admin["username"]
      private_key = file(var.vm_admin["private_key"])
      host        = element(azurerm_public_ip.pip.*.fqdn, count.index)
    }
  }

  provisioner "file" {
    source      = "./runner/cloudinitstatus.sh"
    destination = "~/cloudinitstatus.sh"

    connection {
      type        = "ssh"
      user        = var.vm_admin["username"]
      private_key = file(var.vm_admin["private_key"])
      host        = element(azurerm_public_ip.pip.*.fqdn, count.index)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/cloudinitstatus.sh && cd ~/ && ./cloudinitstatus.sh",
      "sudo mv ~/gitlab.crt /usr/local/share/ca-certificates/gitlab.crt",
      "sudo update-ca-certificates",
      "echo '${var.gitlab_server["internal_ip"]} ${var.gitlab_server["fqdn"]}' | sudo tee -a /etc/host",
      "cd ~/ && wget https://github.com/docker/docker-credential-helpers/releases/download/v0.6.4/docker-credential-secretservice-v0.6.4-amd64.tar.gz && tar -xf docker-credential-secretservice-v0.6.4-amd64.tar.gz && chmod +x docker-credential-secretservice && sudo mv /usr/bin/docker-credential-secretservice /usr/bin/docker-credential-secretservice.bkp && sudo mv docker-credential-secretservice /usr/bin/",
      "chmod +x ~/custom-agent/configure-runners.sh && cd ~/custom-agent && ./configure-runners.sh ${data.azurerm_user_assigned_identity.msi.client_id} ${var.gitlab_server["token"]} https://${var.gitlab_server["fqdn"]}/ ${var.vm_prefix}-${count.index} ${var.gitlab_server["fqdn"]} ${var.gitlab_server["internal_ip"]}"
    ]

    connection {
      type        = "ssh"
      user        = var.vm_admin["username"]
      private_key = file(var.vm_admin["private_key"])
      host        = element(azurerm_public_ip.pip.*.fqdn, count.index)
    }
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo mv ~/gitlab.crt /usr/local/share/ca-certificates/gitlab.crt",
  #     "sudo update-ca-certificates",
  #     "echo '${var.gitlab_server["internal_ip"]} ${var.gitlab_server["fqdn"]}' | sudo tee -a /etc/host",
  #     "chmod +x ~/custom-agent/configure-runners.sh && cd ~/custom-agent && ./configure-runners.sh ${data.azurerm_user_assigned_identity.msi.client_id} ${var.gitlab_server["token"]} https://${var.gitlab_server["fqdn"]}/ ${var.vm_prefix}-${count.index} ${var.gitlab_server["fqdn"]} ${var.gitlab_server["internal_ip"]}"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = var.vm_admin["username"]
  #     private_key = file(var.vm_admin["private_key"])
  #     host        = element(azurerm_public_ip.pip.*.fqdn, count.index)
  #   }
  # }
}
