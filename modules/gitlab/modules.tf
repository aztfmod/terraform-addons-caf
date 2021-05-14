module "gitlab_projects" {
  source          = "./module/gitlab"
  for_each        = var.gitlab_projects
  project         = each.value
}

output gitlab_projects {
  value = module.gitlab_projects
}
