terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = ">=4.9.2"
    }
  }
}

provider "github" {
  # Configuration options
}