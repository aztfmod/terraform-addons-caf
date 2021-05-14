# resource "random_string" "prefix" {
#   count   = try(var.global_settings.prefix, null) == null ? 1 : 0
#   length  = 4
#   special = false
#   upper   = false
#   number  = false
# }

# resource "random_string" "alpha1" {
#   count   = try(var.global_settings.prefix, null) == null ? 1 : 0
#   length  = 1
#   special = false
#   upper   = false
#   number  = false
# }

# locals {

#   prefix = lookup(var.global_settings, "prefix", null) == null ? random_string.prefix.0.result : var.global_settings.prefix

#   global_settings = {
#     default_region     = lookup(var.global_settings, "default_region", "region1")
#     environment        = lookup(var.global_settings, "environment", var.environment)
#     inherit_tags       = try(var.global_settings.inherit_tags, false)
#     passthrough        = try(var.global_settings.passthrough, false)
#     prefix             = local.prefix == "" ? null : [local.prefix]
#     prefix_start_alpha = local.prefix == "" ? null : format("%s%s", try(random_string.alpha1.0.result, ""), local.prefix)
#     prefix_with_hyphen = local.prefix == "" ? null : format("%s-", local.prefix)
#     random_length      = try(var.global_settings.random_length, 0)
#     regions            = var.global_settings.regions
#     use_slug           = try(var.global_settings.use_slug, true)
#   }

#   client_config = var.client_config == {} ? {
#     client_id               = data.azurerm_client_config.current.client_id
#     landingzone_key         = var.current_landingzone_key
#     logged_aad_app_objectId = local.object_id
#     logged_user_objectId    = local.object_id
#     object_id               = local.object_id
#     subscription_id         = data.azurerm_client_config.current.subscription_id
#     tenant_id               = data.azurerm_client_config.current.tenant_id
#   } : map(var.client_config)

#   object_id = coalesce(var.logged_user_objectId, var.logged_aad_app_objectId, try(data.azurerm_client_config.current.object_id, null), try(data.azuread_service_principal.logged_in_app.0.object_id, null))

# }
