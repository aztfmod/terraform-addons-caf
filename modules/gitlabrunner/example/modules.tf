module "gitlab_runner" {
  source          = "../module"
  for_each        = var.gitlab_runner
  runner          = each.value
}

output gitlab_runner {
  value = module.gitlab_runner
}