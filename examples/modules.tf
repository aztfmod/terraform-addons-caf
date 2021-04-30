module "caf" {
  source = "../"

  global_settings                = var.global_settings
  gitlab_projects                = var.gitlab_projects
  github_projects                = var.github_projects
  azure_devops_projects          = var.azure_devops_projects
  jenkins_projects               = var.jenkins_projects
  current_landingzone_key        = var.landingzone.key
  tenant_id                      = var.tenant_id
  logged_user_objectId           = var.logged_user_objectId
  logged_aad_app_objectId        = var.logged_aad_app_objectId
  resource_groups                = var.resource_groups
  tags                           = local.tags
}
