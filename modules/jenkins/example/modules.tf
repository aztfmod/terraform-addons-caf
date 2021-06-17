module "jenkins_projects" {
  source          = "../module"
  for_each        = var.jenkins_projects
  project         = each.value
}

output "jenkins_projects" {
  value = module.jenkins_projects
}
