module "azuredevops_projects" {
  source          = "../module"
  for_each        = var.azuredevops_projects
  project         = each.value
  global_settings = local.global_settings
  client_config   = local.client_config
}

output azuredevops_projects {
  value = module.azuredevops_projects
}
