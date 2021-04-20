# GitLab CAF Module

This submodule is part of [Cloud Adoption Framework](https://github.com/aztfmod/terraform-azurerm-caf) landing zones for [GitLab on Terraform](https://github.com/gitlabhq/terraform-provider-gitlab).

You can instantiate this submodule directly using the following parameters:

```terraform
module "gitlab_projects" {
  source  = "aztfmod/caf/azurerm/modules/devops/providers/gitlab"
  version = "3.5.0"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| gitlabhq/gitlab | >=3.5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project | The project configuration map | `map` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The Project ID. |
| name | The Project name. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Example Usage (Guideline)

- Clone desired CAF launchpad and configuration repo, for demo purposes, you can use [CAF Launchpad repo](https://github.com/Azure/caf-terraform-landingzones)

```bash
git clone https://github.com/Azure/caf-terraform-landingzones public
```

- Export required environment variables

```bash
export ENVIRONMENT=<name_of_the_environment> # such as, demo, staging, production, etc.
export GITLAB_TOKEN=<token_created_at_gitlab.com_or_gitlab_server> # created on gitlab.com or gitlab server

# run the following command if you're using gitlab server
export GITLAB_BASE_URL=<url_of_the_gitlab_server>
```

- Provision Cloud Adoption Framework (CAF) Launchpad resources by executing the following script

```bash
rover -lz ./public/landingzones/caf_launchpad -launchpad -var-folder ./public/caf_launchpad/scenario/100 -parallelism 30 -level level0 -env ${ENVIRONMENT} -a apply
```

- Add GitLab project and couple of project variables into Level 1 (_Foundation Level_)

```bash
rover -lz ./examples/ -var-folder ./examples/gitlab/new_project/ -level level1 -env ${ENVIRONMENT} -a apply
```

If you want to change the GitLab project configuration or project variables, see the example configuration in [examples/gitlab/new_project/gitlab_project.tfvars](./examples/gitlab/new_project/gitlab_project.tfvars) file;

```terraform
gitlab_projects = {
  test_project  = {
    name        = "test_project"
    description = "test project description"
    visibility  = "private"

    variables = {
      var1 = {
        value = "testvalue1"
        protected = true
        masked = false
      }
      var2 = {
        value = "testvalue2"
        protected = false
        masked = true
      }
      var3 = {
        value = "testvalue3"
        protected = true
      }
      var4 = {
        value = "testvalue4"
        masked = true
      }
    }
  }
}
```

> After it finish running (it may take couple of minutes) you'll see a project is created in the GitLab instance, with couple of project variables
