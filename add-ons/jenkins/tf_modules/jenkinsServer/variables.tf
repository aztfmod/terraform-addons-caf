
#  Name for the VM instance
variable "vmName" {
    description = "Name to use for the VM instance"
    type = string
}

# Name for the resource group
variable "resourceGroupName" {
    description = "Name to use for the resource group"
    type = string
}

# Azure location
variable "location" {
    description = "Azure resource location e.g., eastus"
    type = string
}

# A prefix to apply to all the related resources
# in the RG.  Note that if vmName is specified,
# that will be the name of the VM.  If it is not
# specified, a name will be constructed.
variable "resourcePrefix" {
    description = "A prefix to apply to inferred resource names in the resource group."
    type = string
    default = null
}

variable "tags" {
    description = "A map of resource tags to apply to each resource"
    type = map
    default = null
}

variable "serverSku" {
    description = "Optional override of the server SKU"
    type = string
    default = null
}

# Note: for actual defaults for the 3 admin* variables, see locals in jenkins.tf

variable "adminUser" {
    description = "Linux userid to use for ssh during Jenkins software install"
    type = string
    default = null
}

variable "adminUserSSHPrivateKeyFile" {
    description = "Private key file path for adminUser"
    type = string
    default = null
}

variable "adminUserSSHPublicKeyFile" {
    description = "Public key file path for adminUser"
    type = string
    default = null
}

variable "vnetAddressSpace" {
    description = "CIDR for the VNET"
    type = string
    default = "10.0.0.0/20"
}

variable "subnetAddressSpace" {
    description = "CIDR for the VNET subnet containing the Jenkins private IP"
    type = string
    default = "10.0.0.0/24"
}
