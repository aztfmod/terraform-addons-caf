module "jenkins_projects" {
  source          = "./modules/jenkins"
  for_each        = var.jenkins_projects
  project         =  each.value
  # project       = var.jenkins_projects["test_project"]
}

output "jenkins_projects" {
  value = module.jenkins_projects
}
