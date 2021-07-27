locals {

  resource_group_name = var.resource_group_name
  location            = data.azurerm_resource_group.resource_group.location

  vm_admin_username    = var.vm_admin_username != null ? var.vm_admin_username : local._default_admin.username
  vm_admin_public_key  = var.vm_admin_public_key != null ? var.vm_admin_public_key : local._default_admin.public_key
  vm_admin_private_key = var.vm_admin_private_key != null ? var.vm_admin_private_key : local._default_admin.private_key

  vm_prefix  = var.vm_prefix != null ? var.vm_prefix : local._default_vm.prefix
  vm_size    = var.vm_size != null ? var.vm_size : local._default_vm.size
  vm_storage = var.vm_storage != null ? var.vm_storage : local._default_vm.storage

  vm_image_publisher = var.vm_image_publisher != null ? var.vm_image_publisher : local._default_vm_image.publisher
  vm_image_offer     = var.vm_image_offer != null ? var.vm_image_offer : local._default_vm_image.offer
  vm_image_sku       = var.vm_image_sku != null ? var.vm_image_sku : local._default_vm_image.sku
  vm_image_version   = var.vm_image_version != null ? var.vm_image_version : local._default_vm_image.version

  gitlab_server_cert_path   = var.gitlab_server_cert_path != null ? var.gitlab_server_cert_path : local._default_glserver.cert_path
  gitlab_server_internal_ip = var.gitlab_server_internal_ip
  gitlab_server_fqdn        = var.gitlab_server_fqdn
  gitlab_server_token       = var.gitlab_server_token

  subnet_id = "${data.azurerm_resources.vnet.resources[0].id}/subnets/${var.vnet_subnet}"

  full_mode  = var.full_mode != null ? var.full_mode : local._default_full_mode
  _full_mode = local.full_mode == true
  vm_count   = local._full_mode ? 4 : 1

  tags = merge(
    {
      server_role  = "GitLabRunner",
      last_updated = timestamp()
  }, var.tags)


  #   # a bit of fiddling for resource prefixes as underscores aren't allowed in some names
  #   _p0 = var.resourcePrefix == null ? local._vmNameTmp : var.resourcePrefix
  #   _p1 = replace(local._p0,"_","-")
  #   # check if the prefix starts with a digit -- which can cause naming issues.
  #   # If it is a digit, replace the lead character with 'P'
  #   _p2 = contains(["0","1","2","3","4","5","6","7","8","9"], substr(local._p1,0,1)) ? "P${substr(local._p1,1,length(local._p1)-1)}" : local._p1
  #   _p = local._p2

  #   #
  #   # Names for the various resources
  #   #
  #   nameRG = var.resourceGroupName
  #   # if we weren't given a VM name, construct one prefixed by the common resource prefix.
  #   nameVM = local._constructVMName ? "${local._p}-${local._vmNameTmp}" : local._vmNameTmp
  #   nameVNET = "${local._p}-vnet"
  #   namePublicIP = "${local._p}-pip"
  #   nameSubnet01 = "${local._p}-sn-1"
  #   nameNic01 = "${local._p}-nic-1"

  #   # Which Azure region/location for the Server
  #   location = var.location
}