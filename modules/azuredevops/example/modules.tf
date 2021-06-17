module "azuredevops_projects" {
  source          = "../module"
  for_each        = var.azuredevops_projects
  project         = each.value
}

output azuredevops_projects {
  value = module.azuredevops_projects
}
