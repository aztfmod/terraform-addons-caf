output "project_name" {
  value = github_repository_project.project.name
}

output project_url {
  value = github_repository_project.project.url
}

output repo_id {
  value = github_repository.repository.repo_id
}

output repo_url {
  value = github_repository.repository.html_url
}

output repo_name {
  value = github_repository.repository.full_name
}
