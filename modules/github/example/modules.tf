module "github_projects" {
  source          = "../module"
  for_each        = var.github_projects
  project         = each.value
}

output github_projects {
  value = module.github_projects
}
