#
# Outputs from the Jenkins Server module for a single instance.
#

output "internal_ip" {
  description = "Internal IP address"
  value = azurerm_linux_virtual_machine.jenvm.private_ip_address
}

output "public_ip" {
  description = "Public IP address"
  value = azurerm_linux_virtual_machine.jenvm.public_ip_address
}

output "admin_id" {
  description = "admin user"
  value = local.adminUser
}

output "admin_SSH_Info" {
  description = "admin SSH Information"
  value = {
      "publicKeyFile" = local.adminUserSSHPublicKeyFile,
      "privateKeyFile" = local.adminUserSSHPrivateKeyFile,
  }
}

output "resource_group" {
  description = "Name of Resource group containing the VM instance"
  value = local.nameRG
}

output "location" {
  description = "Azure region where the VM instance is located"
  value = local.location
}

output "sku" {
  description = "VM SKU for the server.  e.g. Standard_F2"
  value = local.serverSku
}

output "tags" {
  description = "Tags from provisioned VM"
  value = azurerm_linux_virtual_machine.jenvm.tags
}

output "vm_resource_id" {
  description = "Azure resource ID for the provisioned VM"
  value = azurerm_linux_virtual_machine.jenvm.id
}
