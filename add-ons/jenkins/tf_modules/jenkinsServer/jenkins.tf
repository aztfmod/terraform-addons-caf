#
# Jenkins server module
#
# Provision a VM with a public and private IP, on it's own subnet in a new VNET.
#

resource "random_id" "vmPart" {  # used only if no suggested VM name was provided
  byte_length = 4
}

locals {
  # See optionalVars.tf for default values.

  # Fix up defaulted admin user information
  adminUser = var.adminUser != null ? var.adminUser : local._defaultUserInfo.userid
  adminUserSSHPublicKeyFile = var.adminUserSSHPublicKeyFile != null ? var.adminUserSSHPublicKeyFile : local._defaultUserInfo.publicKey
  adminUserSSHPrivateKeyFile = var.adminUserSSHPrivateKeyFile != null ? var.adminUserSSHPrivateKeyFile : local._defaultUserInfo.privateKey

  # Fix up defaulted size of Jenkins Server VM instance -- e.g. "Standard_F2"
  serverSku = var.serverSku != null ? var.serverSku : local._defaultSKU

  # Did we receive a VM name or should we construct one?
  _constructVMName = var.vmName == null
  _vmNameTmp = local._constructVMName ? "Jenkins-${random_id.vmPart.b64_std}" : var.vmName

  # a bit of fiddling for resource prefixes as underscores aren't allowed in some names
  _p0 = var.resourcePrefix == null ? local._vmNameTmp : var.resourcePrefix
  _p1 = replace(local._p0,"_","-")
  # check if the prefix starts with a digit -- which can cause naming issues.
  # If it is a digit, replace the lead character with 'P'
  _p2 = contains(["0","1","2","3","4","5","6","7","8","9"], substr(local._p1,0,1)) ? "P${substr(local._p1,1,length(local._p1)-1)}" : local._p1
  _p = local._p2

  #
  # Names for the various resources
  #
  nameRG = var.resourceGroupName
  # if we weren't given a VM name, construct one prefixed by the common resource prefix.
  nameVM = local._constructVMName ? "${local._p}-${local._vmNameTmp}" : local._vmNameTmp
  nameVNET = "${local._p}-vnet"
  namePublicIP = "${local._p}-pip"
  nameSubnet01 = "${local._p}-sn-1"
  nameNic01 = "${local._p}-nic-1"

  # Handle the case of possibly-missing tag values
  tags = merge(
      {
        environment = "Jenkins",
        serverRole = "Jenkins",
        lastUpdated = timestamp()
      }, var.tags)

  # Which Azure region/location for the Server
  location = var.location
}

# Note: in the following resources, the lifecycle tag ensures that
# the resource is never updated solely because we keep the
# local.tags value "lastUpdated" at the timestamp current.
# i.e., reflecting the time of the current terraform execution.

resource "azurerm_resource_group" "jenrg" {
  name      = local.nameRG
  location  = local.location

  tags      = local.tags
  lifecycle { ignore_changes = [ tags["lastUpdated"] ] }
}

resource "azurerm_virtual_network" "jennetwork" {
    depends_on = [azurerm_resource_group.jenrg]
    name                = local.nameVNET
    location            = local.location
    resource_group_name = local.nameRG
    address_space       = [ var.vnetAddressSpace ]

    tags                = local.tags
    lifecycle { ignore_changes = [ tags["lastUpdated"] ] }
}

resource "azurerm_subnet" "jensubnet" {
    depends_on = [azurerm_virtual_network.jennetwork]
    name                  = local.nameSubnet01
    virtual_network_name  = azurerm_virtual_network.jennetwork.name
    resource_group_name   =  local.nameRG
    address_prefixes      = [ var.subnetAddressSpace ]
}

resource "azurerm_public_ip" "jnPubIP" {
    depends_on = [azurerm_resource_group.jenrg]
    name                = local.namePublicIP
    location            = local.location
    resource_group_name = local.nameRG
    allocation_method   = "Static"
    idle_timeout_in_minutes = 30
    tags                = local.tags
    lifecycle { ignore_changes = [ tags["lastUpdated"] ] }
}

resource "azurerm_network_interface" "jennic01" {
  depends_on = [azurerm_resource_group.jenrg]
  name                = local.nameNic01
  location            = local.location
  resource_group_name = local.nameRG

  tags                = local.tags
  lifecycle { ignore_changes = [ tags["lastUpdated"] ] }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jensubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jnPubIP.id
  }
}

# Creating and Configuring the VM Instance

locals {
    # packages needed for Jenkins
    jdk = "openjdk-8-jdk"

    # Convenient definitions for brevity in the Jenkins install (see provisioner below)
    aptPrefix = "sudo DEBIAN_FRONTEND=noninteractive apt --yes -qq"
    aptUpdate = "${local.aptPrefix} update "
    aptInstall = "${local.aptPrefix} install "
}

resource "azurerm_linux_virtual_machine" "jenvm" {
  depends_on = [azurerm_resource_group.jenrg, azurerm_network_interface.jennic01 ]
  name                = local.nameVM
  location            = local.location
  resource_group_name = local.nameRG
  size                = local.serverSku
  network_interface_ids = [
      azurerm_network_interface.jennic01.id,
  ]
  tags                = local.tags
  lifecycle { ignore_changes = [ tags["lastUpdated"] ] }

  admin_username      = local.adminUser
  admin_ssh_key {
    username   = local.adminUser
    public_key = file(local.adminUserSSHPublicKeyFile)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # base OS image
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  # Install the Jenkins software
  provisioner "remote-exec" {
    inline = [
      # general update
      "echo '===[01]==='; ${local.aptUpdate}",
      # install Java SDK
      "echo '===[02]==='; ${local.aptInstall} ${local.jdk}",
      # Install Jenkins
      "echo '===[03]==='; wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
      "echo '===[04]==='; sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'",
      "echo '===[05]==='; ${local.aptUpdate}",
      "echo '===[06]==='; ${local.aptInstall} jenkins",
      # Start Jenkins service
      "echo '===[07]==='; sudo systemctl start jenkins",
      "echo '===[08]===';",
    ]
    connection {
      type = "ssh"
      user = local.adminUser
      private_key = file(local.adminUserSSHPrivateKeyFile)
      host = azurerm_public_ip.jnPubIP.ip_address
    }
  }
}
