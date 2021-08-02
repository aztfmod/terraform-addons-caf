module "glrunner" {
  for_each = try(var.glrunner, {})
  source   = "./module"

  resource_group_name = each.value.resource_group_name
  tags              = local.tags_computed
  full_mode         = each.value.full_mode

  vm_admin_username    = lookup(each.value, "vm_admin_username", null)
  #vm_admin_public_key  = lookup(each.value, "vm_admin_public_key", null)
  #vm_admin_private_key = lookup(each.value, "vm_admin_private_key", null)

  vm_prefix  = lookup(each.value, "vm_prefix", null)
  vm_size    = lookup(each.value, "vm_size", null)
  vm_storage = lookup(each.value, "vm_storage", null)

  vm_image_publisher = lookup(each.value, "vm_image_publisher", null)
  vm_image_offer     = lookup(each.value, "vm_image_offer", null)
  vm_image_sku       = lookup(each.value, "vm_image_sku", null)
  vm_image_version   = lookup(each.value, "vm_image_version", null)

  #gitlab_server_cert        = lookup(each.value, "gitlab_server_cert", null)
  gitlab_server_internal_ip = lookup(each.value, "gitlab_server_internal_ip", null)
  gitlab_server_fqdn        = lookup(each.value, "gitlab_server_fqdn", null)
  vnet_subnet               = lookup(each.value, "gitlab_server_subnet_name", null)
  
  ci_workspace        = lookup(each.value, "ci_workspace", null)
}
