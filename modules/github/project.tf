resource "github_repository" "repository" {
  name         = lookup(var.project, "name", "")
  description  = lookup(var.project, "description", "")
  visibility   = lookup(var.project, "visibility", "private")
  has_issues   = true
  has_projects = true
}

resource "github_repository_project" "project" {
  name       = lookup(var.project, "name", "")
  repository = github_repository.repository.name
  body       = lookup(var.project, "description", "")
}